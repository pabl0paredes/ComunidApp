class ShowChat < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :is_hidden, presence: true
end
