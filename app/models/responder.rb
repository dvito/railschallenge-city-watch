class Responder < ActiveRecord::Base

  self.primary_key = "name"

  belongs_to :emergency, foreign_key: "emergency_code"

  validates :type,
            presence: true
  validates :name,
            presence: true,
            uniqueness: true
  validates :capacity, 
            presence: true,
            inclusion: { in: 1..5 }

  def self.total_capacity
    all
  end

  def self.available_capacity
    where("emergency_code IS NULL")
  end

  def self.on_duty_capacity
    where(on_duty: true)
  end

  def self.available_and_on_duty_capacity
    where("emergency_code IS NULL").where(on_duty: true)
  end

  def self.capacity_report
    [
      total_capacity.sum(:capacity), 
      available_capacity.sum(:capacity), 
      on_duty_capacity.sum(:capacity), 
      available_and_on_duty_capacity.sum(:capacity)
    ]
  end
end
