class Booking < ApplicationRecord
  
  include Neighbor::Model
  has_neighbors :embedding, dimensions: 1536


  belongs_to :resident
  belongs_to :common_space


  validates :start, :end, presence: true
  validate :end_after_start
  validate :no_overlap


  after_create :set_embedding

  private

  def end_after_start
    return if start.blank? || self.end.blank?

    if self.end <= start
      errors.add(:end, "debe ser posterior al inicio")
    end
  end

  def no_overlap
    return if start.blank? || self.end.blank?

    overlapping = Booking.where(common_space_id: common_space_id)
                         .where.not(id: id)
                         .where('"start" < ? AND "end" > ?', self.end, start)

    if overlapping.exists?
      errors.add(:base, "El horario seleccionado ya está ocupado")
    end
  end

  def set_embedding
    client = OpenAI::Client.new

    text = <<~TEXT
      Reserva:
      - Espacio común: #{common_space.name}
      - Usuario: #{resident.user.name}
      - Fecha inicio: #{start.strftime("%Y-%m-%d %H:%M")}
      - Fecha fin: #{self.end.strftime("%Y-%m-%d %H:%M")}
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
