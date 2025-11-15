class Chat < ApplicationRecord
  belongs_to :community
  has_many :messages, dependent: :destroy
  has_many :show_chats, dependent: :destroy

  validates :name, :category, presence: true
  validates :name, uniqueness: { scope: :community_id }
  validates :name, length: { maximum: 25 }
  validates :category, inclusion: { in: ['General', 'Mantenimiento', 'Eventos', 'Seguridad', 'Otros'] }
end
