class UsableHour < ApplicationRecord
  include Neighbor::Model
  belongs_to :common_space

  validates :start, :end, presence: true

  has_neighbors :embedding, dimensions: 1536
  after_create :set_embedding

  private

  def set_embedding
    client = OpenAI::Client.new

    text = <<~TEXT
      Horario disponible:
      - Espacio común: #{common_space.name}
      - Fecha: #{date}
      - Hora: #{start_time} a #{end_time}
      - Disponible: #{is_available}
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
