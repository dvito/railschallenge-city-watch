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

  after_create :dispatch
  after_save :relieve_responders, 
    if: Proc.new { |model| model.resolved_at != nil }
  
  def dispatch
    ["Fire", "Police", "Medical"].each do |type|
      if send("#{type.downcase}_severity") > 0
        dispatch_by_type_and_severity(type, send("#{type.downcase}_severity"))
      end
      check_type_and_severity(type, send("#{type.downcase}_severity"))
    end
    save!
  end

  def check_type_and_severity(type, severity)
    if responders && responders.by_type(type).sum(:capacity) >= severity 
      full_response = true 
    else
      if severity == 0
        full_response = true 
      else
        full_response = false
      end
    end
  end

  def dispatch_by_type_and_severity(type, severity)
    type.constantize.on_duty.available.with_capacity(severity).order("capacity ASC").each do |responder|
        if severity > 0
          responders << responder
          severity -= responder.capacity
        end
    end
    type.constantize.on_duty.available.
      order("capacity DESC").each do |responder|
      if severity > 0
        responders << responder
        severity -= responder.capacity
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
    responders = []
  end

end
