class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    if %w(volunteer volunteer_manager department_assistant super_admin).include?(current_user.role)
      @user_schedules = current_user.user_schedules.includes(department_block: [:day, :department]).limit(5)
      @past_assignments = current_user.check_ins.where(status: '2').includes(user_schedule: {department_block: [:day, :department]}).order("check_out_time DESC").limit(5).decorate
    end
  end
end
