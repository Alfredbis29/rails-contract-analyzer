require 'openai'

module Llm
  class ClauseExtractor
    CHUNK_SIZE = 2000
    OVERLAP = 200

    # Initializes the ClauseExtractor with OpenAI client
    def initialize(api_key: ENV['OPENAI_API_KEY'])
      @client = OpenAI::Client.new(access_token: api_key)
    end

    # Main entry point: returns array of clause hashes
    # Handles chunking, API calls, and error logging
    def extract_clauses(contract_text)
      chunks = chunk_text(contract_text)
      results = []
      chunks.each_with_index do |chunk, idx|
        begin
          response = call_openai(chunk)
          parsed = parse_response(response)
          results.concat(parsed)
          Rails.logger.info("Chunk #{idx + 1}/#{chunks.size} processed successfully.")
        rescue StandardError => e
          Rails.logger.error("ClauseExtractor failed on chunk #{idx + 1}: #{e.class} - #{e.message}")
          Rails.logger.error(e.backtrace.join("\n"))
        end
      end
      results
    end

    private

    def chunk_text(text)
      return [] if text.blank?
      chunks = []
      i = 0
      while i < text.length
        chunk = text[i, CHUNK_SIZE]
        chunks << chunk
        i += (CHUNK_SIZE - OVERLAP)
      end
      chunks
    end

    def call_openai(chunk)
      prompt = <<~PROMPT
        Extract all clauses from the following contract text. For each clause, return a JSON object with:
        - clause_type (string)
        - risk_level (string: low, medium, high)
        - risk_reason (string)
        - suggested_redline (string)
        Respond as a JSON array of objects. Only output valid JSON.
        Contract text:
        #{chunk}
      PROMPT
      @client.chat(
        parameters: {
          model: "gpt-4",
          messages: [
            { role: "system", content: "You are a legal contract clause extraction assistant." },
            { role: "user", content: prompt }
          ],
          temperature: 0.2
        }
      )['choices'][0]['message']['content']
    end

    def parse_response(response)
      JSON.parse(response)
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parse error: #{e.message}")
      []
    end
  end
end
