class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    @question = question

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai
      }
    )

    new_content = chatgpt_response["choices"][0]["message"]["content"]

    @question.update(ai_answer: new_content)

    
    Turbo::StreamsChannel.broadcast_update_to(
      "question_#{@question.id}",
      target: dom_id(@question),
      partial: "questions/question",
      locals: { question: @question }
    )
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def questions_formatted_for_openai
    questions = @question.user.questions.order(:created_at)
    results   = []


    system_text = <<~TEXT
      Eres un asistente para residentes de ComunidApp.
      Responde siempre en español, de forma clara y amable.
      Si no sabes algo sobre la comunidad, acláralo.
    TEXT

    results << { role: "system", content: system_text }


    questions.each do |q|
      results << { role: "user",      content: q.user_question }
      results << { role: "assistant", content: q.ai_answer || "" }
    end

    results
  end
end
