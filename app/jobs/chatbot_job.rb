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

    # 🔧 Normalizar enlaces de reserva (forzar show del espacio)
    new_content = new_content.gsub(
      /\/common_spaces\/(\d+)\/bookings(\/new)?/,
      '/common_spaces/\1'
    )

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

    # Identificación del usuario
    user_role = @question.user.administrator.present? ? "admin" : "resident"
    community_id = @question.user.community&.id || Community.find_by(administrator_id: @question.user.id)&.id

    system_text = <<~TEXT
      Eres el asistente oficial de ComunidApp.
      Respondes siempre en español, de manera clara, breve y útil.

      --- INFORMACIÓN DEL USUARIO ---
      El usuario actual es un: #{user_role}.
      El ID de la comunidad es: #{community_id}.

      --- REGLAS GENERALES ---
      - Usa exclusivamente el contexto proporcionado abajo.
      - Si falta información, NO digas "no tengo información" ni frases similares.
      - En su lugar, ofrece siempre el enlace correspondiente para que el usuario pueda consultarlo.
      - No inventes comunidades, gastos, residentes ni administradores.
      - Nunca inventes dominios externos (como example.com). Usa solo rutas relativas:
          /communities/{id}/common_expenses

      --- FORMATO DE ENLACES (HTML) ---
      - Tus respuestas se muestran directamente como HTML.
      - Por eso, NUNCA uses formato Markdown.
      - Debes usar SIEMPRE etiquetas HTML <a> con rutas relativas:
          <a href="/comunidades/...">Texto</a>

      --- REGLAS CUANDO FALTA INFORMACIÓN ---
      Si el contexto no contiene datos suficientes para responder con precisión:
        - Si la pregunta es sobre gastos/deudas:
            "Te sugiero revisar los gastos comunes:
            <a href='/communities/{community_id}/common_expenses'>Ver gastos comunes</a>"
        - Si es sobre chats:
            "Puedes revisar tus chats aquí:
            <a href='/communities/{community_id}/chats'>Ver chats</a>"
        - Si es general:
            "Puedes revisar la información aquí:
            <a href='/communities/{community_id}'>Ver información de la comunidad</a>"

      --- ACCIONES DE CREACIÓN ---
      La palabra "reservar" NO significa crear un recurso nuevo.
      Reservar SIEMPRE debe seguir la lógica de reservas, incluso para residentes.
      Nunca trates "reservar" como "crear".
      Si el usuario quiere CREAR, REGISTRAR o AGREGAR algo nuevo:

      1) Si el usuario es "admin":
          - Proporciona SIEMPRE el enlace correcto:
              • Crear gasto común:
                <a href="/communities/{community_id}/common_expenses/new">Registrar gasto común</a>
              • Crear espacio común:
                <a href="/communities/#{community_id}/common_spaces/new">Crear espacio común</a>
              • Crear chat:
                <a href="/communities/#{community_id}/chats/new">Nuevo chat</a>

      2) Si el usuario es "resident":
          - Responde:
            "Para crear este tipo de recurso necesitas permisos de administrador.
            Puedes contactarte con un Administrador o ver la información de la comunidad aquí:
            <a href='/communities/#{community_id}'>Ver información de la comunidad</a>"

      --- SOBRE EL ADMINISTRADOR ---
      - Si en el contexto aparece el nombre del administrador, puedes mencionarlo.
      - Si el usuario pregunta cómo contactarlo:
          <a href="/communities/#{community_id}">Ver información de la comunidad</a>

      --- LINKS INTERNOS (HTML) ---
      1) Gastos comunes:
          <a href="/communities/#{community_id}/common_expenses">Ver gastos comunes</a>

      2) Espacios comunes:
          <a href="/communities/#{community_id}/common_spaces">Ver espacios comunes</a>

      3) Reservas:
          <a href="/common_spaces/{space_id}/bookings/new">Reservar espacio</a>

      4) Residentes:
          <a href="/communities/#{community_id}/residents">Ver residentes</a>

      5) Información general:
          <a href="/communities/#{community_id}">Ver mi comunidad</a>

      6) Chats:
          <a href="/communities/#{community_id}/chats">Ver chats</a>

      --- ESTILO ---
      - Responde como si hablaras con un residente real.
      - Evitá explicaciones técnicas.
      - Mantené las respuestas naturales y breves.

      --- CONTEXTO ---
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
