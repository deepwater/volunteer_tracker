class Dashboard::VolunteersController < DashboardController
  before_filter :volunteer?

  def index
    # TODO: fetch day differents way for each format
    @day = Day.where("year = ? AND month = ? AND mday = ?", params[:year], params[:month], params[:day]).first
    respond_to do |format|
      format.html
      format.json { render json: VolunteerDatatable.new(view_context, { spectator: current_user, day: Day.find(params[:day]) }) }
    end
  end

  private
  
    def volunteer?
      redirect_to :root if current_user.has_role? :volunteer
    end

end
