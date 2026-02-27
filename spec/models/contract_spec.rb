require 'rails_helper'

RSpec.describe Contract, type: :model do
  it 'is invalid without a title' do
    contract = Contract.new(content: 'Sample content')
    expect(contract).not_to be_valid
  end

  it 'is invalid without content' do
    contract = Contract.new(title: 'Sample')
    expect(contract).not_to be_valid
  end

  it 'is valid with title and content' do
    contract = Contract.new(title: 'Sample', content: 'Sample content')
    expect(contract).to be_valid
  end

  describe '.with_high_risk' do
    it 'returns contracts with high risk flags' do
      high_risk = Contract.create!(title: 'High', content: '...', risk_flags: ['high'])
      low_risk = Contract.create!(title: 'Low', content: '...', risk_flags: ['low'])
      expect(Contract.with_high_risk).to include(high_risk)
      expect(Contract.with_high_risk).not_to include(low_risk)
    end
  end

  describe 'status enum' do
    it 'defaults to draft' do
      contract = Contract.create!(title: 'Enum', content: '...', risk_flags: [])
      expect(contract.status).to eq('draft')
    end

    it 'can be set to active' do
      contract = Contract.create!(title: 'Enum2', content: '...', risk_flags: [], status: :active)
      expect(contract.status).to eq('active')
    end
  end
end
