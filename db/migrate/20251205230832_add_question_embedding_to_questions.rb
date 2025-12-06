class AddQuestionEmbeddingToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :question_embedding, :vector , limit: 1536
  end
end
