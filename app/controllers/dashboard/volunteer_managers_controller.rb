class Dashboard::VolunteerManagersController < DashboardController

  def create
    @volunteer_manager = VolunteerManager.new(params[:volunteer_manager])

    respond_to do |format|
      if @volunteer_manager.save
        format.html { redirect_to dashboard_department_block_path(@volunteer_manager.department_block), notice: 'Volunteer Manager was successfully created.' }
        format.json { render json: @volunteer_manager, status: :created, location: @volunteer_manager.department_block }
      else
        format.html { render action: "new" }
        format.json { render json: @volunteer_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @volunteer_manager = VolunteerManager.find(params[:id])
    @volunteer_manager.destroy

    respond_to do |format|
      format.html { redirect_to [:dashboard, @volunteer_manager.department_block] }
      format.json { head :no_content }
    end
  end
end