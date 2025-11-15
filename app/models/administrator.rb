class Administrator < ApplicationRecord
  belongs_to :user
  has_many :communities
end
