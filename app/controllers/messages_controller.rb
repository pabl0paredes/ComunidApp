class MessagesController < ApplicationController
  before_action :set_chat, only: [:create]
  before_action :set_message, only: [:destroy]

  def create
    @message = @chat.messages.build(message_params)
    @message.user = current_user

    authorize @message

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_message_form",
            partial: "messages/form",
            locals: { chat: @chat, message: @message }
          )
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @message  # ✅ Pundit

    chat = @message.chat   # guardar antes de borrar
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
    params.require(:message).permit(:content, files: [])
  end
end
