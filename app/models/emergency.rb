class Emergency < ActiveRecord::Base

  self.primary_key = "code"

  has_many :responders, foreign_key: "emergency_code"

  has_many :fires, foreign_key: "emergency_code"
  has_many :polices, foreign_key: "emergency_code"
  has_many :medicals, foreign_key: "emergency_code"

  validates :code, 
            presence: true, 
            uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity, 
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :dispatch, 
    if: Proc.new { |model| model.resolved_at == nil }
  after_save :relieve_responders, 
    if: Proc.new { |model| model.resolved_at != nil && model.responders.count != 0 }
  
  def dispatch
    ["Fire", "Police", "Medical"].each do |type|
      if send("#{type.downcase}_severity") > 0
        dispatch_by_type(type, send("#{type.downcase}_severity"))
      end
    end
    # determine_full_response
    if fires.sum(:capacity) >= fire_severity &&
      polices.sum(:capacity) >= police_severity &&
      medicals.sum(:capacity) >= medical_severity
        full_response = true
    end
    save!
  end

  def dispatch_by_type(type, severity)
    # first check that there is one with enough capacity
    if Responder.available_and_on_duty_capacity.where("capacity <= #{severity}").sum(:capacity) > severity
      # next check that ones with less capcity, can cover it by adding them together
      Responder.available_and_on_duty_capacity.where("capacity <= #{severity}").order("capacity DESC").each do |responder|
        if severity >= 0
          severity -= responder.capacity
          responders << responder
        end
      end
    else
      Responder.available_and_on_duty_capacity.where("capacity >= #{severity}").order("capacity ASC").each do |responder|
        if severity >= 0
          severity -= responder.capacity
          responders << responder
        end
      end
    end 
  end

  def self.full_responses
    [ 
      Emergency.where(full_response: true).count, 
      Emergency.all.count 
    ]
  end

  def relieve_responders
    responders.destroy_all
  end

end
