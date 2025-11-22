class MessagesController < ApplicationController
  before_action :set_chat, only: [:create]
  before_action :set_message, only: [:destroy]
  before_action :authenticate_admin_or_owner!, only: [:destroy]

  def create
    @message = @chat.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    end
  end

  def destroy
    chat = @message.chat  # guardamos el chat ANTES de borrar
    @message.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chat_path(chat), notice: "Mensaje eliminado" }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  # 🔒 Admin o dueño del mensaje puede borrar
  def authenticate_admin_or_owner!
    unless current_user.administrator.present? || @message.user == current_user
      redirect_to chat_path(@message.chat), alert: "No tenés permiso para eliminar este mensaje."
    end
  end
end

