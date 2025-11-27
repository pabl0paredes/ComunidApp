class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  has_many_attached :files

  # debe tener texto o archivos
  validates :content, length: { maximum: 500 }
  validate :content_or_files_present

  private

  def content_or_files_present
    if content.blank? && !files.attached?
      errors.add(:base, "El mensaje debe tener texto o al menos un archivo.")
    end
  end
end
