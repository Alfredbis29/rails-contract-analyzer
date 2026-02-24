class AddExtractedClausesAndRiskFlagsToContracts < ActiveRecord::Migration[7.1]
  def change
    add_column :contracts, :extracted_clauses, :jsonb, default: []
    add_column :contracts, :risk_flags, :jsonb, default: []
  end
end
