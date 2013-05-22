class UserScheduleMailer < ActionMailer::Base

  def schedule_email(user_schedule)
  	@user = user_schedule.user
  	@department_block = user_schedule.department_block
  	@department = @department_block.department

    mail(to: @user.email, cc: @user.secondary_email.to_s == '' ? nil : @user.secondary_email, from: "noreply@volunteer.gilroygarlicfestival.com", subject: "You have been scheduled!")
  end

  def unschedule_email(user_schedule)
  	@user = user_schedule.user
  	@department_block = user_schedule.department_block
  	@department = @department_block.department

    mail(to: @user.email, cc: @user.secondary_email.to_s == '' ? nil : @user.secondary_email, from: "noreply@volunteer.gilroygarlicfestival.com", subject: "You have been unscheduled!")
  end
end
