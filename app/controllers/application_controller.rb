class ApplicationController < ActionController::Base
	before_action :set_default_title

	private

	def set_default_title
		@page_title = "Contract Analyzer"
	end
end
