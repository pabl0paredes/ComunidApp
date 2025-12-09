# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  # def index
  #   # 1. Buscar si existe una sesión previa
  #   old_session = ChatSession.find_by(user: current_user)

  #   # 2. Si existe, borrar todo y eliminarla
  #   if old_session
  #     old_session.questions.delete_all
  #     old_session.destroy
  #   end

  #   # 3. Crear una sesión nueva y limpia
  #   @chat_session = ChatSession.create!(user: current_user)

  #   # 4. Sin preguntas (acaba de generarse)
  #   @questions = []

  #   # 5. Crear pregunta nueva asociada a esta sesión
  #   @question = Question.new(chat_session: @chat_session, user: current_user)

  #   authorize @question
  # end

  def index
    @chat_session = ChatSession.find_or_create_by(user: current_user)

    @questions = @chat_session.questions.order(:created_at)

    @question = Question.new(chat_session: @chat_session, user: current_user)

    authorize @question
  end



  # def create
  #   @question = current_user.questions.build(question_params)
  #   @question.chat_session = current_chat_session
  #   authorize @question

  #   if @question.save
  #     # Job asincrónico (pasamos ID para evitar efectos raros con objetos en memoria)
  #     ChatbotJob.perform_later(@question.id)

  #     respond_to do |format|
  #       format.html { redirect_to questions_path }
  #       format.turbo_stream { head :ok } # broadcast del modelo actualiza automáticamente
  #     end
  #   else
  #     @questions = current_chat_session.questions.order(:created_at)
  #     render :index, status: :unprocessable_entity
  #   end
  # end

  def create
    @question = current_user.questions.build(question_params)
    @question.chat_session = current_chat_session
    authorize @question

    if @question.save
      ChatbotJob.perform_later(@question.id)

      respond_to do |format|
        format.html { redirect_to questions_path }

        # ✔ Ahora devolvemos un turbo_stream real
        format.turbo_stream
      end
    else
      @questions = current_chat_session.questions.order(:created_at)

      respond_to do |format|
        format.turbo_stream { render :index, status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity }
      end
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
