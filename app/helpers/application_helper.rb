module ApplicationHelper
	# Formats a date in a readable way
	def formatted_date(date)
		date.strftime("%B %d, %Y") if date.present?
	end
end
