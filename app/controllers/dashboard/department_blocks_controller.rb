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
    @department_block = DepartmentBlock.includes(
      :users, :day, :department, volunteer_managers: :user
    ).find(params[:id])

    user_ids = @department_block.users.map(&:id)
    user_schedules = UserSchedule.includes(:user).where(
      department_block_id: @department_block.id, user_id: user_ids
    ).to_a if user_ids.present?
    @user_schedules = Array.wrap(user_schedules).inject({}) do |result, user_schedule|
      result[user_schedule.user_id] = user_schedule
      result
    end

    user_ids = @department_block.volunteer_managers.map(&:user_id)
    volunteer_managers = VolunteerManager.where(
      department_block_id: @department_block.id,
      user_id: user_ids
    ).to_a if user_ids.present?
    @volunteer_managers = Array.wrap(volunteer_managers).inject({}) do |result, volunteer_manager|
      result[volunteer_manager.user_id] = volunteer_manager
      result
    end

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


    respond_to do |format|
      if @department_block.save
        format.html { redirect_to ("/dashboard/departments/" + @department_block.department.id.to_s + "#" + @department_block.day.safe_short_date), notice: 'Department block was successfully created.' }
        format.json { render json: @department_block, status: :created, location: @department_block }
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

  def export

    day=DateTime.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    department=Department.find(params[:id].to_i)

    csv_string = CSV.generate do |csv|
      csv << ["day", "department_name", "department_block_name", "department_block_start", "department_block_end", "user_fullname"]
      Day.where(month:params[:month].to_i, mday:params[:day].to_i, year:params[:year].to_i).first.department_blocks.where(department_id: params[:id].to_i).all.each do |department_block|
          department_block.users.each_with_index do |user, index|
            line=[
              "#{params[:year].to_i}/#{params[:month].to_i}/#{params[:day].to_i}",
              department_block.department.name,
              department_block.name,
              department_block.start_time,
              department_block.end_time,
              user.full_name
            ]
            csv << line
          end
          if department_block.users.size<1
            line=[
              "#{params[:year].to_i}/#{params[:month].to_i}/#{params[:day].to_i}",
              department_block.department.name,
              department_block.name,
              department_block.start_time,
              department_block.end_time
            ]
            csv << line
          end

        end
    end
    send_data csv_string,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=department_blocks_#{department.name.sub(/\s/,'_')}_#{params[:year].to_i}_#{params[:month].to_i}_#{params[:day].to_i}.csv"
  end
end
