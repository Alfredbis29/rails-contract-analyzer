
# Rails Contract Analyzer

## Setup

1. **Ruby version:** 3.1+
2. **Install dependencies:**
	- `bundle install`
	- `yarn install`
3. **Database setup:**
	- `rails db:create db:migrate db:seed`
4. **Environment variables:**
	- Set `OPENAI_API_KEY` for clause extraction service

## Running

Start the app:
```
bin/dev
```

## Testing

Run tests:
```
bundle exec rspec
```



## Features

- Contract upload and analysis
- Upload contracts
- Automatic clause extraction
- Risk flag detection
- Contract status tracking

- Clause extraction using LLM
- POST /contracts: Upload and analyze a contract
- GET /contracts/:id: View contract details

- Risk flagging
Seed demo contracts with:
	rails db:seed

- Professional UI
Run tests with:
	rspec
- Pagination for contracts list
- Contract status management (draft, active, archived)

## Deployment
Standard Rails deployment. Ensure environment variables are set.

## Contributing
We welcome contributions! Please fork the repository and submit a pull request. For major changes, open an issue first to discuss what you would like to change.
