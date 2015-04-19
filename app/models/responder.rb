class Responder < ActiveRecord::Base

  validates :type,
            presence: true
  validates :name,
            presence: true,
            uniqueness: true
  validates :capacity, 
            presence: true,
            inclusion: { in: 1..5 }

  belongs_to :emergency, foreign_key: "emergency_code"

  def self.total_capacity
    sum(:capacity)
  end

  def self.available_capacity
    where("emergency_code IS NULL").sum(:capacity)
  end

  def self.on_duty_capacity
    where(on_duty: true).sum(:capacity)
  end

  def self.available_and_on_duty_capacity
    where("emergency_code IS NULL").where(on_duty: true).sum(:capacity)
  end

  def self.capacity_report
    [total_capacity, available_capacity, on_duty_capacity, available_and_on_duty_capacity]
  end
end
