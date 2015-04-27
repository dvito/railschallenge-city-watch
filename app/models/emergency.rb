class Emergency < ActiveRecord::Base
  self.primary_key = 'code'

  has_many :responders, foreign_key: 'emergency_code'

  has_many :fires
  has_many :polices
  has_many :medicals

  validates :code,
            presence: true,
            uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :dispatch
  after_save :relieve_responders_after_emergency, if: :resolved_at_changed?

  scope :full_responses, -> { where(full_response: true) }

  def dispatch
    self.full_response = true
    Responder::TYPES.each do |type|
      if self["#{type.downcase}_severity"] > 0
        self.full_response = dispatch_by_type_and_severity(type, self["#{type.downcase}_severity"])
      end
    end
  end

  def dispatch_by_type_and_severity(type, severity)
    return true if dispatch_exact_match(type, severity)
    return true if dispatch_as_capacity_allows(type, severity)
    false
  end

  def dispatch_exact_match(type, severity)
    return false unless Responder.by_type(type).on_duty.available.find_by(capacity: severity)
    responders << Responder.by_type(type).on_duty.available.find_by(capacity: severity)
    true
  end

  def dispatch_as_capacity_allows(type, severity)
    Responder.by_type(type).on_duty.available.order(capacity: :desc).each do |responder|
      severity -= responder.capacity
      responders << responder
      return true if severity <= 0
    end
    false
  end

  def relieve_responders_after_emergency
    responders.clear
  end
end
