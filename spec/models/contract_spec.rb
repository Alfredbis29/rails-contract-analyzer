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
end
