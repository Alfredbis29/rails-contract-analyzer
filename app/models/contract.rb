
class Contract < ApplicationRecord
  has_one_attached :file

  # extracted_clauses: JSONB array of clause hashes
  # risk_flags: JSONB array of high/medium risk clause hashes
end
