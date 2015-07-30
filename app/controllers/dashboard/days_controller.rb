class Dashboard::DaysController < DashboardController

  def index
    @days = Day.all
    respond_to do |format|
      format.json { render json: @days.map { |day| {id: day.id, name: day.long_date} } }
    end
  end

end
