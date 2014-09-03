class Dashboard::VolunteersController < DashboardController

  def index
    respond_to do |format|
      format.html
      format.json { render json: VolunteerDatatable.new(view_context) }
    end
  end

end
