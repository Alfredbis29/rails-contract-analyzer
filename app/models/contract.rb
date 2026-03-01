
class Contract < ApplicationRecord
  has_one_attached :file

  # extracted_clauses: JSONB array of clause hashes
  # risk_flags: JSONB array of high/medium risk clause hashes

  # Status enum
  enum status: { draft: 0, active: 1, archived: 2 }, _prefix: true

  # Scope to filter contracts with high risk flags
  scope :with_high_risk, -> { where("risk_flags::text LIKE '%high%'") }

  # Validations
  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :content, presence: true, length: { minimum: 100 }
  validates :extracted_clauses, length: { maximum: 5000 }, allow_nil: true
  validates :risk_flags, length: { maximum: 1000 }, allow_nil: true
  validate :extracted_clauses_format
  validate :risk_flags_format

  private

  def extracted_clauses_format
    if extracted_clauses.present? && !extracted_clauses.is_a?(Array)
      errors.add(:extracted_clauses, 'must be an array of clause hashes')
    end
  end

  def risk_flags_format
    if risk_flags.present? && !risk_flags.is_a?(Array)
      errors.add(:risk_flags, 'must be an array of risk flag hashes')
    end
  end
end
