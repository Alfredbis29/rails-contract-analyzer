# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

Contract.create!(
	title: 'Employment Agreement',
	content: 'This contract outlines the terms of employment between the company and the employee. Confidentiality and non-compete clauses apply. Termination may occur for cause or without cause with notice.',
	extracted_clauses: [
		{ text: 'Confidentiality clause', risk_level: 'medium' },
		{ text: 'Non-compete clause', risk_level: 'high' }
	],
	risk_flags: [
		{ text: 'Non-compete clause', risk_level: 'high' }
	],
	status: :active
)

Contract.create!(
	title: 'Service Agreement',
	content: 'This contract governs the provision of services. Payment terms are net 30 days. Liability is limited. Termination requires 30 days notice.',
	extracted_clauses: [
		{ text: 'Payment terms', risk_level: 'low' },
		{ text: 'Liability limitation', risk_level: 'medium' }
	],
	risk_flags: [
		{ text: 'Liability limitation', risk_level: 'medium' }
	],
	status: :draft
)
