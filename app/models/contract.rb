
class Contract < ApplicationRecord
  has_one_attached :file

  # extracted_clauses: JSONB array of clause hashes
  # risk_flags: JSONB array of high/medium risk clause hashes
  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :extracted_clauses, length: { maximum: 5000 }, allow_nil: true
  validates :risk_flags, length: { maximum: 1000 }, allow_nil: true
end
