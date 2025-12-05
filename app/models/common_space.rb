class CommonSpace < ApplicationRecord
  include Neighbor::Model
  has_neighbors :embedding, dimensions: 1536

  belongs_to :community
  has_many :bookings, dependent: :destroy
  has_many :usable_hours, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :community_id }
  validates :name, length: { maximum: 50 }


  validates :is_available, presence: true

  after_create :set_embedding

  private

  def set_embedding
    client = OpenAI::Client.new

    text = <<~TEXT
      Espacio común:
      - Nombre: #{name}
      - Ubicación: #{community.name}
      - Descripción: #{description}
    TEXT

    response = client.embeddings(
      parameters: {
        model: "text-embedding-3-small",
        input: text
      }
    )

    update_column(:embedding, response["data"][0]["embedding"])
  end

end
