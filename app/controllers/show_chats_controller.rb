class ShowChatsController < ApplicationController
  before_action :set_show_chat, only: [:update]

  def create
    @show_chat = ShowChat.new(show_chat_params)
    @show_chat.user = current_user

    if @show_chat.save
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path, alert: "No se pudo cambiar la vista."
    end
  end

  def update
    if @show_chat.update(show_chat_params)
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path, alert: "No se pudo actualizar."
    end
  end

  private

  def set_show_chat
    @show_chat = ShowChat.find(params[:id])
  end

  def show_chat_params
    params.require(:show_chat).permit(:chat_id, :is_hidden)
  end
end
