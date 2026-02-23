json.extract! contract, :id, :file, :status, :analysis, :created_at, :updated_at
json.url contract_url(contract, format: :json)
json.file url_for(contract.file)
