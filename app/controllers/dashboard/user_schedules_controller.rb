class Dashboard::UserSchedulesController < ApplicationController

  # POST /user_schedules
  # POST /user_schedules.json
  def create
    @user_schedule = UserSchedule.new(params[:user_schedule])

    respond_to do |format|
      if @user_schedule.save
        format.html { redirect_to [:dashboard, @user_schedule], notice: 'User schedule was successfully created.' }
        format.json { render json: {:template => render_to_string("dashboard/user_schedules/show.json")}}
      else
        format.html { render action: "new" }
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
