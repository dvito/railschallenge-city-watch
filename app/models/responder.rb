class Responder < ActiveRecord::Base
  self.primary_key = 'name'

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
end
