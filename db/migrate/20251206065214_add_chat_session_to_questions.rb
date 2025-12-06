class AddChatSessionToQuestions < ActiveRecord::Migration[7.1]
 def change

    add_reference :questions, :chat_session, foreign_key: true


    say_with_time "Asignando chat_sessions a preguntas antiguas" do
      Question.reset_column_information
      User.find_each do |user|
        session = ChatSession.find_or_create_by!(user: user)
        Question.where(user_id: user.id).update_all(chat_session_id: session.id)
      end
      change_column_null :questions, :chat_session_id, false
    end
  end

end
