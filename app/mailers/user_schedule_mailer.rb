class UserScheduleMailer < ActionMailer::Base

  def schedule_email(user_id, department_block_id)
    @user = User.find(user_id)
    @department_block = DepartmentBlock.find(department_block_id)
    @department = @department_block.department

    mail(to: @user.email, cc: @user.secondary_email.to_s == '' ? nil : @user.secondary_email, from: configatron.noreply, subject: "You have been scheduled!")
  end

  def unschedule_email(user_id, department_block_id)
    @user = User.find(user_id)
    @department_block = DepartmentBlock.find(department_block_id)
    @department = @department_block.department

    mail(to: @user.email, cc: @user.secondary_email.to_s == '' ? nil : @user.secondary_email, from: configatron.noreply, subject: "You have been unscheduled!")
  end
end
