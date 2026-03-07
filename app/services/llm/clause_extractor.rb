class Contract < ApplicationRecord
  # FIX 5: purge the attached blob when the contract is destroyed
  has_one_attached :file, dependent: :purge

  # extracted_clauses: JSONB array of clause hashes
  # risk_flags: JSONB array of risk hashes, each with a "severity" key ("low"/"medium"/"high")

  enum status: { draft: 0, active: 1, archived: 2, expired: 3, pending: 4 }, _prefix: true

  scope :with_high_risk, -> {
    where("risk_flags @> ?", '[{"severity":"high"}]')
  }

  # FIX 4: validate file content type and size when a file is attached
  ACCEPTED_CONTENT_TYPES = %w[application/pdf].freeze
  MAX_FILE_SIZE_MB        = 20

  validates :title,   presence: true,
                      uniqueness: { case_sensitive: false },
                      length: { maximum: 255 }
  validates :content, presence: true, length: { minimum: 100 }

  # FIX 1: removed the no-op `validates :x, allow_nil: true` lines — they do nothing
  # and imply a false sense of validation coverage.

  validate :extracted_clauses_format
  validate :risk_flags_format
  validate :acceptable_file, if: -> { file.attached? }

  private

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

    valid_severities = %w[low medium high]

    risk_flags.each_with_index do |flag, i|
      # FIX 2: support both string and symbol keys for robustness
      severity = flag["severity"] || flag[:severity]

      # FIX 3: explicitly handle nil so the error message is not misleadingly blank
      if severity.nil?
        errors.add(:risk_flags, "element #{i} is missing the 'severity' key")
      elsif !valid_severities.include?(severity)
        errors.add(:risk_flags, "element #{i} has invalid severity '#{severity}' (must be low, medium, or high)")
      end
    end
  end

  # FIX 4: reject disallowed file types and oversized uploads
  def acceptable_file
    unless file.content_type.in?(ACCEPTED_CONTENT_TYPES)
      errors.add(:file, "must be a PDF (got #{file.content_type})")
    end

    if file.byte_size > MAX_FILE_SIZE_MB.megabytes
      errors.add(:file, "must be smaller than #{MAX_FILE_SIZE_MB}MB")
    end
  end
end