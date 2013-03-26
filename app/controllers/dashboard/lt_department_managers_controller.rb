class Dashboard::LtDepartmentManagersController < DashboardController

  # POST /department_managers
  # POST /department_managers.json
  def create
    # LtDepartmentManager.where(:department_id => params[:lt_department_manager][:department_id]).delete_all
    @lt_department_manager = LtDepartmentManager.new(params[:lt_department_manager])

    # Update user role
    @user = @lt_department_manager.user
    @user.role = "department_assistant"
    @user.save

    respond_to do |format|
      if @lt_department_manager.save
        format.html { redirect_to dashboard_department_path(@lt_department_manager.department), notice: 'Lt. Department Manager was successfully created.' }
        format.json { render json: @lt_department_manager, status: :created, location: @lt_department_manager }
      else
        format.html { render action: "new" }
        format.json { render json: @lt_department_manager.errors, status: :unprocessable_entity }
      end
    end
  end
end