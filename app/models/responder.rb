class Responder < ActiveRecord::Base
  self.primary_key = 'name'

  # Disable STI
  self.inheritance_column = :_type_

  TYPES = %w(Fire Police Medical)

  belongs_to :emergency, foreign_key: 'emergency_code'

  validates :type,
            presence: true
  validates :name,
            presence: true,
            uniqueness: true
  validates :capacity,
            presence: true,
            inclusion: { in: 1..5 }

  scope :on_duty, -> { where(on_duty: true) }

  scope :available, -> { where(emergency: nil) }

  scope :by_type, -> (type = nil) { where(type: type) }

  def self.capacity_report
    [
      sum(:capacity),
      available.sum(:capacity),
      on_duty.sum(:capacity),
      available.on_duty.sum(:capacity)
    ]
  end
end
