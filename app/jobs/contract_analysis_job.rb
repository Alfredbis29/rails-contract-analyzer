# frozen_string_literal: true

class ContractAnalysisJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)
    extractor = Llm::ClauseExtractor.new
    clauses = extractor.extract_clauses(contract.body)
    contract.extracted_clauses = clauses
    contract.risk_flags = extract_risk_flags(clauses)
    contract.save!
  rescue => e
    Rails.logger.error("ContractAnalysisJob error: #{e.message}")
    # Optionally, update contract with error info or notify
  end

  private

  def extract_risk_flags(clauses)
    return [] unless clauses.is_a?(Array)
    clauses.select { |c| c['risk_level'] == 'high' || c['risk_level'] == 'medium' }
  end
end
