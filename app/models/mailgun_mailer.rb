class MailgunMailer < ActionMailer::Base

  def self.deliver_schedule_notification_email(user_schedule)

  	@user = user_schedule.user
  	@department_block = user_schedule.department_block
  	@department = @department_block.department

  	emails = [@user.email]
  	emails << @user.secondary_email if @user.secondary_email.to_s.strip.length == 0

  	emails.each do |email|
          mail(:to => "#{email}", :subject => "Garlic Gilroy Festival - You have been scheduled")

	  	RestClient.post API_URL+"/messages", 
	      :from => "omgmediagroup@secret-inlet-9787.herokuapp.com",
	      :to => "#{email}",
	      :subject => "Garlic Gilroy Festival - You have been scheduled",
	      :text => "You have been scheduled to a block at the Gilroy Garlic Festival, here are the details: \n \n Department: #{@department.name} \n Block Name: #{@department_block.name} \n Starting: #{@department_block.readable_start_time} \n Ending: #{@department_block.readable_start_time}"
  	end
  end
end