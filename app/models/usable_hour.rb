class UsableHour < ApplicationRecord
  belongs_to :common_space

  validates :start, :end, :weekday, presence: true
  validates :weekday, inclusion: { in: 1..7 }
end
