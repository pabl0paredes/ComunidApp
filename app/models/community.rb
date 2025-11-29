class Community < ApplicationRecord
  belongs_to :administrator
  has_many :neighbors, dependent: :destroy
  has_many :common_spaces, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :common_expenses, dependent: :destroy

  validates :name, :address, :latitude, :longitude, :size, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 100 }
  validates :address, length: { maximum: 200 }

  def pending_requests
    neighbors.where(is_accepted: false).size
  end

end
