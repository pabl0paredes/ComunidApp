class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :content, presence: true
  validates :content, length: { maximum: 500 }
end
