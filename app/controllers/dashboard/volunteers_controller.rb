class Dashboard::VolunteersController < DashboardController
  before_filter :volunteer?

  def index
    @day = Day.find params[:day_id]
    respond_to do |format|
      format.html
      format.json { render json: VolunteerDatatable.new(view_context, { spectator: current_user, day: @day }) }
    end
  end

  private
  
    def volunteer?
      redirect_to :root if current_user.has_role? :volunteer
    end

end
