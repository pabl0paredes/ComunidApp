class Community < ApplicationRecord

  include Neighbor::Model
  has_neighbors :embedding, dimensions: 1536


  belongs_to :administrator
  has_many :residents, dependent: :destroy
  has_many :common_spaces, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :common_expenses, dependent: :destroy


  after_create :set_embedding


  validates :name, :address, :latitude, :longitude, :size, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 100 }
  validates :address, length: { maximum: 200 }

  def pending_requests
    residents.where(is_accepted: false).size
  end

  private

  def generate_text_for_embedding
    <<~TEXT
      Comunidad: #{name}
      Dirección: #{address}
      Tamaño: #{size}
      Notificaciones: #{notifications}
    TEXT
  end

  def set_embedding
    client = OpenAI::Client.new

    response = client.embeddings(
      parameters: {
        model: "text-embedding-3-small",
        input: generate_text_for_embedding
      }
    )

    update_column(:embedding, response["data"][0]["embedding"])
  end
end
