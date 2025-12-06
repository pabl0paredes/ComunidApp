class ChatSession < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
end
