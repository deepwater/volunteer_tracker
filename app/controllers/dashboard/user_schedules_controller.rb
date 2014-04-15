class Dashboard::UserSchedulesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user_schedules = current_user.user_schedules.includes(:charity, department_block: [:department, :day])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_schedules }
    end
  end

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
        format.json { render json: { template: render_to_string("dashboard/user_schedules/show.json")} }
        format.html do 
          redirect_to dashboard_department_block_path(@user_schedule.department_block, params[:scope]),
            notice: 'User schedule was successfully created.'
        end
      else
        format.html { redirect_to :back, alert: @user_schedule.errors.full_messages.join(', ') }
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
  
  def destroy
    @user_schedule = UserSchedule.find(params[:id])
    @user_schedule.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      # format.html { redirect_to [:dashboard, @user_schedule.department_block] }
      format.json { head :no_content }
    end
  end
  
  def dymo
    @user_schedule = UserSchedule.find(params[:id])
  end
end
