# app/models/question.rb
class Question < ApplicationRecord
  belongs_to :user
  belongs_to :chat_session

  include Neighbor::Model
  has_neighbors :question_embedding, dimensions: 1536

  validates :user_question, presence: true
  validates :user_id, presence: true

  before_create :set_question_embedding

  # 1) Cuando se crea, se agrega a la lista del usuario
  after_create_commit -> {
    broadcast_append_to(
      "questions_user_#{user_id}",
      target: "questions", # <div id="questions">
      partial: "questions/question",
      locals: { question: self }
    )
  }

  private

  def set_question_embedding
    client = OpenAI::Client.new

    response = client.embeddings(
      parameters: {
        model: "text-embedding-3-small",
        input: user_question
      }
    )

    self.question_embedding = response["data"][0]["embedding"]
  end
end
