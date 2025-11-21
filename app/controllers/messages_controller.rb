class MessagesController < ApplicationController
  before_action :set_chat, only: [:create]
  before_action :set_message, only: [:destroy]
  before_action :authenticate_admin!, only: [:destroy]

  def create
    @message = @chat.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to chat_path(@chat)
    else
      @messages = @chat.messages.order(:created_at)
      render "chats/show", status: :unprocessable_entity
    end
  end

  def destroy
    chat = @message.chat
    @message.destroy
    redirect_to chat_path(chat), notice: "Mensaje eliminado."
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

  # ------- 🔒 Seguridad para administradores ----------
  def authenticate_admin!
    unless current_user.administrator.present?
      redirect_to root_path, alert: "No tenés permiso para eliminar mensajes."
    end
  end
end
