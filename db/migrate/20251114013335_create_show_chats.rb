class CreateShowChats < ActiveRecord::Migration[7.1]
  def change
    create_table :show_chats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
