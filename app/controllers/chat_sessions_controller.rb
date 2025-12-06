class ChatSessionsController < ApplicationController
  skip_before_action :authenticate_user!  # Necesario para sendBeacon

  def reset
    session = ChatSession.find_by(id: params[:id])

    if session
      session.questions.delete_all
      session.destroy
    end

    head :ok
  end
end
