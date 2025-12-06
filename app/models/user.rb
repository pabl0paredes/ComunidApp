class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :administrator
  has_one :resident
  has_one :community, through: :resident
  has_many :show_chats
  has_many :messages

  has_many :questions

  validates :name, presence: true
  validates :phone, presence: true
end
