class Dashboard::DepartmentAssistantsController < DashboardController

  # POST /department_managers
  # POST /department_managers.json
  def create
    @department_assistant = DepartmentAssistant.new(params[:department_assistant])

    respond_to do |format|
      if @department_assistant.save
        format.html { redirect_to dashboard_department_path(@department_assistant.department), notice: 'Department Assistant was successfully created.' }
        format.json { render json: @department_assistant, status: :created, location: @department_assistant }
      else
        format.html { render action: "new" }
        format.json { render json: @department_assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department_assistant = DepartmentAssistant.find(params[:id])
    @department_assistant.destroy

    respond_to do |format|
      format.html { redirect_to [:dashboard, @department_assistant.department] }
      format.json { head :no_content }
    end
  end
end