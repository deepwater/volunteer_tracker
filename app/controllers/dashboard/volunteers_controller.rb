class Dashboard::VolunteersController < DashboardController

  def index
    @volunteers = User.with_role(:volunteer)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: VolunteersDatatable.new(view_context) }
    end
  end

end
