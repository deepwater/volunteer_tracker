class UserSchedule < ActiveRecord::Base
	paginates_per 10000

	validates_uniqueness_of :user_id, :scope => :department_block_id

	belongs_to :user
	belongs_to :department_block
	belongs_to :charity

	before_create :add_default_charity
	after_create :deliver_email
	before_destroy :unschedule_email

	has_many :check_ins, foreign_key: :user_schedule_id, primary_key: :id

	def deliver_email
		UserScheduleMailer.delay.schedule_email(self)
	end

	def unschedule_email
		UserScheduleMailer.delay.unschedule_email(self)
	end

	def add_default_charity
		charity_id = nil

		if self.user.user_charities.any?
			charity_id = self.user.user_charities.first.charity.id
		end

		self.charity_id ||= charity_id
	end
	
end
