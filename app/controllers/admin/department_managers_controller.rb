class Admin::DepartmentManagersController < AdminController

  # POST /department_managers
  # POST /department_managers.json
  def create
    DepartmentManager.where(:department_id => params[:department_manager][:department_id]).delete_all
    @department_manager = DepartmentManager.new(params[:department_manager])

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
end