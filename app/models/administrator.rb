class Administrator < ApplicationRecord
  belongs_to :user
  belongs_to :community
end
