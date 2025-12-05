class CommonExpense < ApplicationRecord

  include Neighbor::Model
  has_neighbors :embedding, dimensions: 1536


  belongs_to :community
  has_many :expense_details, dependent: :destroy
  has_many :expense_details_residents, through: :expense_details


  after_create :set_embedding


  validates :date, presence: true
  validates :total,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  
  def amount_for(user)
    return 0 unless user.resident.present?

    expense_details
      .joins(:expense_details_residents)
      .where(expense_details_residents: { resident_id: user.resident.id })
      .sum("expense_details_residents.amount_due")
  end

  def paid_for(user)
    return 0 unless user.resident.present?

    expense_details_residents
      .where(resident_id: user.resident.id, status: "approved")
      .sum(:amount_due)
  end

  private

  def generate_text_for_embedding
    <<~TEXT
      Gasto común:
      Comunidad ID: #{community_id}
      Fecha: #{date}
      Total: #{total}
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
