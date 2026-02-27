module ContractsHelper
	# Highlights risk flags in contract analysis
	def highlight_risk(flag)
		content_tag(:span, flag, class: 'risk-flag')
	end

	# Displays a badge for contract status
	def status_badge(status)
		badge_class = case status.to_s
		when 'draft' then 'bg-gray-200 text-gray-800'
		when 'active' then 'bg-green-200 text-green-800'
		when 'archived' then 'bg-yellow-200 text-yellow-800'
		else 'bg-gray-100 text-gray-600'
		end
		content_tag(:span, status.titleize, class: "px-2 py-1 rounded #{badge_class}")
	end
end
