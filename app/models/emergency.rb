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
    %w(Fire Police Medical).each do |type|
      if send("#{type.downcase}_severity") > 0
        self.full_response = dispatch_by_type_and_severity(type, send("#{type.downcase}_severity"))
      end
    end
  end

  def dispatch_by_type_and_severity(type, severity)
    if type.constantize.on_duty.available.find_by(capacity: severity)
      responders << type.constantize.on_duty.available.find_by(capacity: severity)
      return true
    else
      type.constantize.on_duty.available.order(capacity: :desc).each do |responder|
        severity -= responder.capacity
        responders << responder
        return true if severity <= 0
      end
      return false
    end
  end

  def relieve_responders_after_emergency
    responders.clear
  end
end
