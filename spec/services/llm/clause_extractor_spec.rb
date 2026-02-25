require 'rails_helper'

RSpec.describe Llm::ClauseExtractor do
  let(:extractor) { described_class.new(api_key: 'test') }

  describe '#chunk_text' do
    it 'splits text into chunks' do
      text = 'a' * 5000
      chunks = extractor.send(:chunk_text, text)
      expect(chunks.size).to be > 1
    end
  end

  describe '#extract_clauses' do
    it 'returns an array (mocked)' do
      allow(extractor).to receive(:call_openai).and_return('[{"risk_level":"high"}]')
      allow(extractor).to receive(:parse_response).and_return([{ 'risk_level' => 'high' }])
      result = extractor.extract_clauses('test')
      expect(result).to be_an(Array)
      expect(result.first['risk_level']).to eq('high')
    end
  end
end
