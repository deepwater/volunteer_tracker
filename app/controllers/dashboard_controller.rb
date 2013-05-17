class DashboardController < ApplicationController
	# layout 'dashboard'
	before_filter :authenticate_user!

	def index
		@user_schedules = current_user.user_schedules.limit(5)
	end

	def registration_complete
	end
end
