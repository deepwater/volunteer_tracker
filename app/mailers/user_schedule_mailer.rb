class UserScheduleMailer < ActionMailer::Base

  def schedule_email(user_schedule)
  	@user = user_schedule.user
  	@department_block = user_schedule.department_block
  	@department = @department_block.department

    mail(to: @user.email, from: "schedule@gilroygarlicfestival.com", subject: "You have been scheduled")
  end
end
