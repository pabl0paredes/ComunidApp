class UsableHour < ApplicationRecord
  belongs_to :common_space

  validates :start, :end, presence: true
end
