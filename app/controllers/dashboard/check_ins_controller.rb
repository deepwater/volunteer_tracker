class Dashboard::CheckInsController < DashboardController
  # GET /check_ins
  # GET /check_ins.json
  def index
    @check_ins = CheckIn.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @check_ins }
    end
  end

  # GET /check_ins/1
  # GET /check_ins/1.json
  def show
    @check_in = CheckIn.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_in }
    end
  end

  def scheduled
    @scheduled = []

    # IF THE USER IS A VOLUNTEER MANAGER & ASSIGNED
    if current_user.role? :volunteer_manager and !current_user.volunteer_manager.nil?
      @scheduled = UserSchedule.where(department_block_id: current_user.volunteer_manager.department_block.id)

    # IF THE USER IS A DEPARTMENT ASSISTANT & ASSIGNED
    elsif current_user.role? :department_assistant and !current_user.department_assistant.nil?
      @department_blocks = DepartmentBlock.where(department_id: current_user.department_assistant.department.id)

      @department_blocks.each do |department_block|
        @scheduled << department_block.user_schedules
      end

    #IF THE USER IS A DEPARTMENT MANAGER & ASSIGNED
    elsif current_user.role? :department_manager and !current_user.department_manager.nil?
      @department_blocks = DepartmentBlock.where(department_id: current_user.department_manager.department.id)

      @department_blocks.each do |department_block|
        @scheduled << department_block.user_schedules
      end

    # IF THE USER IS AN EVENT ADMINISTRATOR
    elsif current_user.role? :event_administrator
      @scheduled = UserSchedule.all
    end

    @scheduled.flatten!

    # REMOVE SCHEDULES THAT ARE CHECKED IN
    @scheduled.select!{ |user_schedule|
      !CheckIn.find_by_user_schedule_id(user_schedule.id)
    }

    # ARRANGE THE USER_SCHEDULES BY DATE
    @scheduled.sort_by!{ |user_schedule|
      t = Time.parse("#{user_schedule.department_block.end_time} #{user_schedule.department_block.day.mday}/#{user_schedule.department_block.day.month}/#{user_schedule.department_block.day.year}")
    }

  end

  def active

    @scheduled = []

    # IF THE USER IS A VOLUNTEER MANAGER & ASSIGNED
    if current_user.role? :volunteer_manager and !current_user.volunteer_manager.nil?
      @scheduled = UserSchedule.where(department_block_id: current_user.volunteer_manager.department_block.id)

    # IF THE USER IS A DEPARTMENT ASSISTANT & ASSIGNED
    elsif current_user.role? :department_assistant and !current_user.department_assistant.nil?
      @department_blocks = DepartmentBlock.where(department_id: current_user.department_assistant.department.id)

      @department_blocks.each do |department_block|
        @scheduled << department_block.user_schedules
      end

    #IF THE USER IS A DEPARTMENT MANAGER & ASSIGNED
    elsif current_user.role? :department_manager and !current_user.department_manager.nil?
      @department_blocks = DepartmentBlock.where(department_id: current_user.department_manager.department.id)

      @department_blocks.each do |department_block|
        @scheduled << department_block.user_schedules
      end

    # IF THE USER IS AN EVENT ADMINISTRATOR
    elsif current_user.role? :event_administrator
      @scheduled = UserSchedule.all
    end

    @scheduled.flatten!

    @check_ins = []

    @scheduled.each do |user_schedule|
      user_schedule.check_ins.each do |check_in|
        @check_ins << check_in if check_in.status == "1"
      end
    end

    # ARRANGE THE USER_SCHEDULES BY DATE
    @check_ins.sort_by!{ |check_in|
      t = Time.parse("#{check_in.user_schedule.department_block.end_time} #{check_in.user_schedule.department_block.day.mday}/#{check_in.user_schedule.department_block.day.month}/#{check_in.user_schedule.department_block.day.year}")
    }
  end

  def inactive
    @scheduled = []
  # IF THE USER IS A VOLUNTEER MANAGER & ASSIGNED
    if current_user.role? :volunteer_manager and !current_user.volunteer_manager.nil?
      @scheduled = UserSchedule.where(department_block_id: current_user.volunteer_manager.department_block.id)

    # IF THE USER IS A DEPARTMENT ASSISTANT & ASSIGNED
    elsif current_user.role? :department_assistant and !current_user.department_assistant.nil?
      @department_blocks = DepartmentBlock.where(department_id: current_user.department_assistant.department.id)

      @department_blocks.each do |department_block|
        @scheduled << department_block.user_schedules
      end

    #IF THE USER IS A DEPARTMENT MANAGER & ASSIGNED
    elsif current_user.role? :department_manager and !current_user.department_manager.nil?
      @department_blocks = DepartmentBlock.where(department_id: current_user.department_manager.department.id)

      @department_blocks.each do |department_block|
        @scheduled << department_block.user_schedules
      end


    # IF THE USER IS AN EVENT ADMINISTRATOR
    elsif current_user.role? :event_administrator
      @scheduled = UserSchedule.all
    end

    @scheduled.flatten!

    @check_ins = []

    @scheduled.each do |user_schedule|
      user_schedule.check_ins.each do |check_in|
        @check_ins << check_in if check_in.status == "2" 
      end
    end

    # ARRANGE THE USER_SCHEDULES BY DATE
    @check_ins.sort_by!{ |check_in|
      t = Time.parse("#{check_in.user_schedule.department_block.end_time} #{check_in.user_schedule.department_block.day.mday}/#{check_in.user_schedule.department_block.day.month}/#{check_in.user_schedule.department_block.day.year}")
    }
  end

  # GET /check_ins/new
  # GET /check_ins/new.json
  def new
    @check_in = CheckIn.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_in }
    end
  end

  # GET /check_ins/1/edit
  def edit
    @check_in = CheckIn.find(params[:id])
  end

  # POST /check_ins
  # POST /check_ins.json
  def create
    @check_in = CheckIn.new(params[:check_in])

    respond_to do |format|
      if @check_in.save
        format.html { redirect_to :back, notice: 'Check in was successfully created.' }
        format.json { render json: @check_in, status: :created, location: @check_in }
      else
        format.html { render action: "new" }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_ins/1
  # PUT /check_ins/1.json
  def update
    @check_in = CheckIn.find(params[:id])

    respond_to do |format|
      if @check_in.update_attributes(params[:check_in])
        format.html { redirect_to :back, notice: 'Check in was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_ins/1
  # DELETE /check_ins/1.json
  def destroy
    @check_in = CheckIn.find(params[:id])
    @check_in.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
