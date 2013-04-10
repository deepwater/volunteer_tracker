class Dashboard::DaysController < DashboardController
	def index
	  @days = Day.all

      respond_to do |format|
        format.json { render json: @days }
	  end
	end
end
