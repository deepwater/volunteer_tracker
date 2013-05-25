class UserSchedule < ActiveRecord::Base

	belongs_to :user
	belongs_to :department_block
	belongs_to :charity

	before_create :add_default_charity
	after_create :deliver_email
	after_destroy :unschedule_email

	def deliver_email
		UserScheduleMailer.schedule_email(self).deliver
	end

	def unschedule_email
		UserScheduleMailer.unschedule_email(self).deliver
	end

	def add_default_charity
		charity_id = nil

		if self.user.user_charities.any?
			charity_id = self.user.user_charities.first.charity.id
		end

		self.charity_id ||= charity_id
	end
	
end
