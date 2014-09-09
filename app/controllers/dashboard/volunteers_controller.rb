class Dashboard::VolunteersController < DashboardController

  def index
    # TODO: fetch day differents way for each format
    @day = Day.where("year = ? AND month = ? AND mday = ?", params[:year], params[:month], params[:day]).first
    respond_to do |format|
      format.html
      format.json { render json: VolunteerDatatable.new(view_context, { day: Day.find(params[:day]) }) }
    end
  end

end
