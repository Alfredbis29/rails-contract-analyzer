module ContractsHelper
	# Highlights risk flags in contract analysis
	def highlight_risk(flag)
		content_tag(:span, flag, class: 'risk-flag')
	end
end
