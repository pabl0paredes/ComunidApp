# app/jobs/chatbot_job.rb
class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question_id)
    @question = Question.find(question_id)

    # Si por alguna razón ya tiene respuesta, no hacemos nada
    return if @question.ai_answer.present?

    # Crear contexto RAG
    rag_context = RagContextService.context_for(@question)

    # Llamada al modelo de OpenAI
    client = OpenAI::Client.new

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai(rag_context)
      }
    )

    new_content = chatgpt_response.dig("choices", 0, "message", "content")

    @question.update!(ai_answer: new_content)

    # IMPORTANTE: usamos el broadcast de la propia pregunta
    @question.broadcast_replace_to(
      "questions_user_#{@question.user_id}",
      target: @question,                    # usa dom_id(@question)
      partial: "questions/question",
      locals: { question: @question }
    )

  rescue => e
    Rails.logger.error "[ChatbotJob] Error: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
  end

  private

  def questions_formatted_for_openai(rag_context)
    questions = @question.chat_session.questions.order(:created_at)
    results = []

    system_text = <<~TEXT
      Eres un asistente para residentes de ComunidApp.
      Respondes siempre en español.
      Usa el siguiente contexto para responder preguntas sobre comunidades,
      gastos, detalles, residentes y reservas:

      #{rag_context}
    TEXT

    results << { role: "system", content: system_text }

    questions.each do |q|
      results << { role: "user",      content: q.user_question }
      results << { role: "assistant", content: q.ai_answer || "" }
    end

    results
  end
end
