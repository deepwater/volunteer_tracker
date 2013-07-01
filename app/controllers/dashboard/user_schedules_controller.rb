class Dashboard::UserSchedulesController < ApplicationController

  # POST /user_schedules
  # POST /user_schedules.json

  def index
    @user_schedules = current_user.user_schedules

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_schedules }
    end
  end

  # GET /department_blocks/1
  # GET /department_blocks/1.json
  def show
    @user_schedule = UserSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_schedule }
    end
  end

  def create
    @user_schedule = UserSchedule.new(params[:user_schedule])

    respond_to do |format|
      if @user_schedule.save
        logger.debug "TEST"
        format.html { redirect_to [:dashboard, @user_schedule.department_block], notice: 'User schedule was successfully created.' }
        format.json { redirect_to [:dashboard, @user_schedule.department_block], notice: 'User was succesfully scheduled.' }
      else
        format.html { render action: "new" }
        format.json { render json: @user_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user_schedule = UserSchedule.find(params[:id])

    respond_to do |format|
      if @user_schedule.update_attributes(params[:user_schedule])
        format.html { redirect_to [:dashboard,@user_schedule], notice: 'User Schedule was successfully updated.' }
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
      format.html { redirect_to [:dashboard, @user_schedule.department_block] }
      format.json { head :no_content }
    end
  end
    
end
