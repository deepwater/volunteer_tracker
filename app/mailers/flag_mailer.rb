class FlagMailer < ActionMailer::Base

  def flag_email(flag)
  	@department_managers = flag.check_in.user_schedule.department_block.department.department_managers
  	@check_in = flag.check_in
    @flag = flag
    
    @department_managers.each do |department_manager|
      mail(to: department_manager.user.email, from: configatron.noreply, subject: "A check in has been flagged!")
    end
  end
end
