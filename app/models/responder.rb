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

  scope :on_duty, -> { where(on_duty: true) }

  scope :available, -> { where(emergency_code: nil) }

  scope :by_type, -> (type = nil) { where(type: type) }
  
  scope :with_capacity, -> (capacity = 0) { where('capacity <= ?', capacity) }

  def self.capacity_report
    [
      all.sum(:capacity), 
      available.sum(:capacity), 
      on_duty.sum(:capacity), 
      on_duty.available.sum(:capacity)
    ]
  end
end
