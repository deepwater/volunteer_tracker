class Dashboard::DepartmentBlocksController < DashboardController
  # GET /department_blocks
  # GET /department_blocks.json
  def index
    @department_blocks = DepartmentBlock.all
    @department_block = DepartmentBlock.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @department_blocks }
    end
  end

  # GET /department_blocks/1
  # GET /department_blocks/1.json
  def show
    @department_block = DepartmentBlock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @department_block }
    end
  end

  # GET /department_blocks/new
  # GET /department_blocks/new.json
  def new
    @department_block = DepartmentBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @department_block }
    end
  end

  # GET /department_blocks/1/edit
  def edit
    @department_block = DepartmentBlock.find(params[:id])
  end

  # POST /department_blocks
  # POST /department_blocks.json
  def create
    @department_block = DepartmentBlock.new(params[:department_block])

    start_time = Time.parse(@department_block.start_time)
    @department_block.start_time = start_time.strftime("%H:%M")

    end_time = Time.parse(@department_block.end_time)
    @department_block.end_time = end_time.strftime("%H:%M")


    duration = end_time-start_time

    redirect_to ("/dashboard/departments/" + @department_block.department.id.to_s + "#" + @department_block.day.safe_short_date), :flash => { :error => "Your end time must be after your start time" } if end_time-start_time<=0

    respond_to do |format|
      if duration>0 && @department_block.save
        format.html { redirect_to ("/dashboard/departments/" + @department_block.department.id.to_s + "#" + @department_block.day.safe_short_date), notice: 'Department block was successfully created.' }
        format.json { render json: @department_block, status: :created, location: @department_block }
      elsif duration<0
        format.html { redirect_to ("/dashboard/departments/" + @department_block.department.id.to_s + "#" + @department_block.day.safe_short_date), :flash => { :error => "Your end time must be after your start time" } }
      else
        format.html { render action: "new" }
        format.json { render json: @department_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /department_blocks/1
  # PUT /department_blocks/1.json
  def update
    @department_block = DepartmentBlock.find(params[:id])

    respond_to do |format|
      if @department_block.update_attributes(params[:department_block])
        format.html { redirect_to dashboard_department_block_path(@department_block), notice: 'Department block was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @department_block.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy
    @day = Day.find(params[:id])

    @day_to_copy_to = Day.find(params[:day_to_copy_to])

    @department = Department.find(params[:department_id])

    @department.department_blocks.where("day_id = ?", @day.id).all.each do |department_block|
      new_record = department_block.dup
      new_record.day_id = @day_to_copy_to.id
      new_record.save
    end

    redirect_to ("/dashboard/departments/" + @department.id.to_s + "#" + @day_to_copy_to.safe_short_date), notice: 'Department blocks were successfully copied.'

  end

  # DELETE /department_blocks/1
  # DELETE /department_blocks/1.json
  def destroy
    @department_block = DepartmentBlock.find(params[:id])
    @department_block.destroy

    respond_to do |format|
      # format.html { redirect_to dashboard_department_url(@department_block.department) }
      format.html { redirect_to dashboard_department_url(@department_block.department) }
      format.json { head :no_content }
    end
  end
end