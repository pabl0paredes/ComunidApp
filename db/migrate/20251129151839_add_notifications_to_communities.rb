class AddNotificationsToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_column :communities, :notifications, :integer, default: 0
  end
end
