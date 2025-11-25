class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :administrator
  has_one :neighbor
  has_one :community, through: :neighbor
  has_many :show_chats
  has_many :messages

  validates :name, presence: true
  validates :phone, presence: true
end
