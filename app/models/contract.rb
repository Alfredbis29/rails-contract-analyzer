class Contract < ApplicationRecord
  has_one_attached :file

  # extracted_clauses: JSONB array of clause hashes
  # risk_flags: JSONB array of risk hashes, each with a "severity" key ("low"/"medium"/"high")

  # FIX 1: added :expired and :pending to match all statuses used in ContractsHelper
  enum status: { draft: 0, active: 1, archived: 2, expired: 3, pending: 4 }, _prefix: true

  # FIX 2: use JSONB containment operator instead of fragile LIKE cast.
  # Matches rows where risk_flags contains at least one element with {"severity":"high"}.
  scope :with_high_risk, -> {
    where("risk_flags @> ?", '[{"severity":"high"}]')
  }

  # Validations
  # FIX 4: case_sensitive: false prevents "Title" and "title" being treated as unique.
  # Ensure a DB-level unique index exists: add_index :contracts, :title, unique: true
  validates :title,   presence: true,
                      uniqueness: { case_sensitive: false },
                      length: { maximum: 255 }
  validates :content, presence: true, length: { minimum: 100 }

  # FIX 3: removed meaningless `length` validators on JSONB array columns.
  # `length: { maximum: N }` counts array elements, not bytes — misleading and wrong.
  # Use a custom size guard below if payload limits are needed.
  validates :extracted_clauses, allow_nil: true
  validates :risk_flags,        allow_nil: true

  validate :extracted_clauses_format
  validate :risk_flags_format

  private

  # FIX 5: validate that each element in the array is a Hash, not just the array itself.
  def extracted_clauses_format
    return if extracted_clauses.nil?

    unless extracted_clauses.is_a?(Array) && extracted_clauses.all? { |c| c.is_a?(Hash) }
      errors.add(:extracted_clauses, "must be an array of clause hashes")
    end
  end

  def risk_flags_format
    return if risk_flags.nil?

    unless risk_flags.is_a?(Array) && risk_flags.all? { |f| f.is_a?(Hash) }
      errors.add(:risk_flags, "must be an array of risk flag hashes")
      return
    end

    # FIX 5 (continued): validate that severity values are within allowed set
    valid_severities = %w[low medium high]
    risk_flags.each_with_index do |flag, i|
      severity = flag["severity"]
      unless valid_severities.include?(severity)
        errors.add(:risk_flags, "element #{i} has invalid severity '#{severity}' (must be low, medium, or high)")
      end
    end
  end
end