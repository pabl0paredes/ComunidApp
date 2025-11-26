class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:edit, :update]
  before_action :load_categories, only: [:index, :new, :edit]

  def index
    @community = Community.find(params[:community_id])

    # Pundit requiere policy_scope en index
    @chats = policy_scope(@community.chats)
    authorize @chats

    @category_descriptions = {
      "General" => "Conversaciones generales de la comunidad.",
      "Mantenimiento" => "Reportes, arreglos y mejoras en el edificio.",
      "Eventos" => "Organización de reuniones y actividades comunitarias.",
      "Seguridad" => "Alertas, avisos y temas relacionados con la seguridad.",
      "Otros" => "Cualquier conversación que no encaja en las demás categorías."
    }

    hidden_chat_ids = ShowChat.where(user: current_user, is_hidden: true).pluck(:chat_id)
    @visible_chats = @chats.where.not(id: hidden_chat_ids)
    @hidden_chats  = @chats.where(id: hidden_chat_ids)
  end

  def new
    @community = Community.find(params[:community_id])
    @chat = @community.chats.new
    authorize @chat
  end

  def create
    @community = Community.find(params[:community_id])
    @chat = @community.chats.build(chat_params)
    authorize @chat

    if @chat.save
      redirect_to chat_path(@chat), notice: "Chat creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @chat

    @messages = @chat.messages.includes(:user).order(created_at: :asc)
    @message  = Message.new

    @show_chat = ShowChat.find_or_create_by!(
      user: current_user,
      chat: @chat
    )
  end

  def edit
    authorize @chat
  end

  def update
    authorize @chat
    if @chat.update(chat_params)
      redirect_to chat_path(@chat), notice: "Chat actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @chat
    community = @chat.community
    @chat.destroy
    redirect_to community_chats_path(community), notice: "Chat eliminado."
  end

  def hidden

    authorize Chat

    @hidden_chats = ShowChat.where(user: current_user, is_hidden: true)
                            .includes(:chat)
                            .map(&:chat)
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:category)
  end

  def require_admin
    unless current_user.administrator.present?
      redirect_to chat_path(@chat), alert: "No tenés permiso para hacer eso."
    end
  end

  def load_categories
    @categories = ["General", "Mantenimiento", "Eventos", "Seguridad", "Otros"]
  end
end
