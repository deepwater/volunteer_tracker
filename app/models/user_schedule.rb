class UserSchedule < ActiveRecord::Base

	require 'mailgun_mailer'

	belongs_to :user
	belongs_to :department_block

	after_create :deliver_email

	def deliver_email
		MailgunMailer.deliver_schedule_notification_email(self)
	end
end
