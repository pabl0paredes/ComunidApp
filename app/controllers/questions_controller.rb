# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  def index
    # 1. Obtener o crear la única sesión del usuario
    @chat_session = current_chat_session

    # 2. Cargar solo las preguntas de esa sesión
    @questions = @chat_session.questions.order(:created_at)

    # 3. Pregunta nueva ya asociada a esa sesión
    @question = Question.new(
      chat_session: @chat_session,
      user: current_user
    )

    authorize @question
  end

  def create
    @question = current_user.questions.build(question_params)
    @question.chat_session = current_chat_session
    authorize @question

    if @question.save
      # Job asincrónico (pasamos ID para evitar efectos raros con objetos en memoria)
      ChatbotJob.perform_later(@question.id)

      respond_to do |format|
        format.html { redirect_to questions_path }
        format.turbo_stream { head :ok } # broadcast del modelo actualiza automáticamente
      end
    else
      @questions = current_chat_session.questions.order(:created_at)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:user_question)
  end

  def current_chat_session
    ChatSession.find_or_create_by(user: current_user)
  end
end
