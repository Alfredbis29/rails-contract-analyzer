class ContractAnalysisJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)
    extractor = Llm::ClauseExtractor.new
    begin
      clauses = extractor.extract_clauses(contract.body)
      contract.extracted_clauses = clauses
      contract.risk_flags = extract_risk_flags(clauses)
      contract.save!
      Rails.logger.info("Contract #{contract_id} analyzed successfully.")
    rescue StandardError => e
      Rails.logger.error("ContractAnalysisJob failed for contract #{contract_id}: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      # Optionally, notify error tracking service here
    end
  end

  private

  def extract_risk_flags(clauses)
    return [] unless clauses.is_a?(Array)
    clauses.select { |c| c['risk_level'] == 'high' || c['risk_level'] == 'medium' }
  end
end
