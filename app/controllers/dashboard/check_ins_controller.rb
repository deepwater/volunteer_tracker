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

    # CREATE A BLANK ARRAY FOR STORING SCHEDULES
    @schedules = []

    # GET ALL THE USER SCHEDULES AND CHECK THEM IN THE ARRAY
    Day.all.each do |day|
      @schedules << day.user_schedules
    end

    # FLATTEN THE ARRAY
    @schedules.flatten!

    # REMOVE SCHEDULES THAT ARE CHECKED IN
    @schedules.select!{ |user_schedule|
      !CheckIn.find_by_user_schedule_id(user_schedule.id)
    }

    # ARRANGE THE USER_SCHEDULES BY DATE
    @schedules.sort_by!{ |user_schedule|
      t = Time.parse("#{user_schedule.department_block.end_time} #{user_schedule.department_block.day.mday}/#{user_schedule.department_block.day.month}/#{user_schedule.department_block.day.year}")
    }

  end

  def active
    @check_ins = CheckIn.where(status: "1")
  end

  def inactive
    @check_ins = CheckIn.where(status: "2")
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
      format.html { redirect_to check_ins_url }
      format.json { head :no_content }
    end
  end
end
