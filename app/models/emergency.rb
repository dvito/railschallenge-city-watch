class Emergency < ActiveRecord::Base

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity, 
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :dispatch, 
    if: Proc.new { |model| model.resolved_at == nil }
  after_save :relieve_responders, 
    if: Proc.new { |model| model.resolved_at != nil && model.responders.count != 0 }

  has_many :responders, foreign_key: "emergency_code"

  has_many :fires, foreign_key: "emergency_code"
  has_many :polices, foreign_key: "emergency_code"
  has_many :medicals, foreign_key: "emergency_code"
  
  def dispatch
    dispatch_fire if fire_severity > 0
    dispatch_police if police_severity > 0
    dispatch_medical if medical_severity > 0
    if fires.sum(:capacity) >= fire_severity &&
      polices.sum(:capacity) >= police_severity &&
      medicals.sum(:capacity) >= medical_severity
        full_response = true
    end
    save!
  end

  def dispatch_fire
    running_total = 0
      f_units = Fire.where(
        "capacity <= #{fire_severity} AND emergency_code IS NULL").where(
        on_duty: true).order(
        "capacity DESC")
      f_units.each do |fire|
        if running_total < fire_severity
          responders << fire
          running_total += fire.capacity
        end
      end
    if running_total < fire_severity
      f_units = Fire.where(
        "capacity >= #{fire_severity} AND emergency_code IS NULL").where(
        on_duty: true).order(
        "capacity ASC")
      f_units.each do |fire|
        if running_total < fire_severity
          responders << fire
          running_total += fire.capacity
        end
      end
    end
  end

  def dispatch_police
    running_total = 0
    p_units  = Police.where(
      "capacity <= #{police_severity} AND emergency_code IS NULL").where(
      on_duty: true).order(
      "capacity DESC")
    p_units.each do |police|
      if running_total < police_severity
        responders << police
        running_total += police.capacity
      end
    end
  end

  def dispatch_medical
    running_total = 0
    m_units  = Medical.where(
      "capacity <= #{medical_severity} AND emergency_code IS NULL").where(
      on_duty: true).order(
      "capacity DESC")
    m_units.each do |medical|
      if running_total < medical_severity
        responders << medical
        running_total += medical.capacity
      end
    end
  end

  def self.full_responses
    [ Emergency.where(full_response: true).count, Emergency.all.count ]
  end

  def relieve_responders
    responders.destroy_all
  end

end
