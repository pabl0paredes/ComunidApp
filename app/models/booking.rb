class Booking < ApplicationRecord
  belongs_to :resident
  belongs_to :common_space

  validates :start, :end, presence: true
  validate :end_after_start
  validate :no_overlap

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

end
