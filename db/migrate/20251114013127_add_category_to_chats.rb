class AddCategoryToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :category, :string
  end
end
