class AddDefaultToShowChatsIsHidden < ActiveRecord::Migration[7.1]
  def change
    change_column_default :show_chats, :is_hidden, false
    change_column_null :show_chats, :is_hidden, false, false
  end
end
