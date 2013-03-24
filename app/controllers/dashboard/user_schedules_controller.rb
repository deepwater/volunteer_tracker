class Dashboard::UserSchedulesController < ApplicationController
  # GET /user_schedules
  # GET /user_schedules.json
  def index
    @user_schedules = UserSchedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_schedules }
    end
  end

  # GET /user_schedules/1
  # GET /user_schedules/1.json
  def show
    @user_schedule = UserSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_schedule }
    end
  end

  # GET /user_schedules/new
  # GET /user_schedules/new.json
  def new
    @user_schedule = UserSchedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_schedule }
    end
  end

  # GET /user_schedules/1/edit
  def edit
    @user_schedule = UserSchedule.find(params[:id])
  end

  # POST /user_schedules
  # POST /user_schedules.json
  def create
    @user_schedule = UserSchedule.new(params[:user_schedule])

    respond_to do |format|
      if @user_schedule.save
        format.html { redirect_to [:dashboard, @user_schedule], notice: 'User schedule was successfully created.' }
        format.json { render :json => {:full_name => @user_schedule.user.full_name }}
      else
        format.html { render action: "new" }
        format.json { render json: @user_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_schedules/1
  # PUT /user_schedules/1.json
  def update
    @user_schedule = UserSchedule.find(params[:id])

    respond_to do |format|
      if @user_schedule.update_attributes(params[:user_schedule])
        format.html { redirect_to [:dashboard, @user_schedule], notice: 'User schedule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_schedules/1
  # DELETE /user_schedules/1.json
  def destroy
    @user_schedule = UserSchedule.find(params[:id])
    @user_schedule.destroy

    respond_to do |format|
      format.html { redirect_to [:dashboard, :user_schedules] }
      format.json { head :no_content }
    end
  end
end
