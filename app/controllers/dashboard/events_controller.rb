class Dashboard::EventsController < DashboardController

  def calendar
    @events = Event.all
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

end
