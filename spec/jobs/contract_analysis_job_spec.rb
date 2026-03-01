require 'rails_helper'

RSpec.describe ContractAnalysisJob, type: :job do
  let(:contract) { Contract.create!(title: 'Test', content: 'A' * 200) }

  it 'extracts clauses and risk flags' do
    allow_any_instance_of(Llm::ClauseExtractor).to receive(:extract_clauses).and_return([
      { 'text' => 'Clause 1', 'risk_level' => 'high' },
      { 'text' => 'Clause 2', 'risk_level' => 'low' }
    ])
    expect {
      described_class.perform_now(contract.id)
    }.to change { contract.reload.extracted_clauses }.from(nil)
    expect(contract.risk_flags).to eq([{ 'text' => 'Clause 1', 'risk_level' => 'high' }])
  end

  it 'handles errors gracefully' do
    allow_any_instance_of(Llm::ClauseExtractor).to receive(:extract_clauses).and_raise(StandardError.new('API error'))
    expect {
      described_class.perform_now(contract.id)
    }.not_to raise_error
  end
end
