class Resident < ApplicationRecord
  include Neighbor::Model
  has_neighbors :embedding, dimensions: 1536

  belongs_to :user
  belongs_to :community

  has_many :bookings, dependent: :destroy
  has_many :expense_details_residents, dependent: :destroy
  has_many :expense_details, through: :expense_details_residents

  validates :unit, presence: true, length: { maximum: 10 }
  validates :unit, uniqueness: { scope: :community_id }

  validates :common_expense_fraction,
            presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  after_create :set_embedding

  private

  def set_embedding
    client = OpenAI::Client.new

    text = <<~TEXT
      Residente de una comunidad:
      - Nombre del usuario: #{user.name}
      - Unidad: #{unit}
      - Comunidad: #{community.name}
      - Porcentaje de gastos comunes asignado: #{common_expense_fraction}%
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

