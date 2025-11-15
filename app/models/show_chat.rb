class ShowChat < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :is_hidden, inclusion: { in: [true, false] }
end
