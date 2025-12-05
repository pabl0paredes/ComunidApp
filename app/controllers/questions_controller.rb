class QuestionsController < ApplicationController
  def index
    @question  = Question.new
    @questions = policy_scope(Question)

    authorize @question
  end

  def create
    @questions = policy_scope(Question)
    @question  = Question.new(question_params)
    @question.user = current_user

    authorize @question

    if @question.save
      
      ChatbotJob.perform_later(@question)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "questions",
            partial: "questions/question",
            locals: { question: @question }
          )
        end

        format.html { redirect_to questions_path }
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:user_question)
  end
end
