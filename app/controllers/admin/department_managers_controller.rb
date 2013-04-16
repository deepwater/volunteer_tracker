class Admin::DepartmentManagersController < AdminController

  # POST /department_managers
  # POST /department_managers.json
  def create
    @department_manager = DepartmentManager.new(params[:department_manager])

    # Update user role
    @user = @department_manager.user
    @user.role = "department_manager"
    @user.save

    respond_to do |format|
      if @department_manager.save
        format.html { redirect_to admin_department_path(@department_manager.department), notice: 'Department Manager was successfully created.' }
        format.json { render json: @department_manager, status: :created, location: @department_manager }
      else
        format.html { render action: "new" }
        format.json { render json: @department_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department_manager = DepartmentManager.find(params[:id])
    @department_manager.destroy

    respond_to do |format|
      format.html { redirect_to [:dashboard, @department_manager.department] }
      format.json { head :no_content }
    end
  end
end