# == Schema Information
#
# Table name: user_schedules
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  department_block_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class UserSchedule < ActiveRecord::Base

	belongs_to :user
	belongs_to :department_block

	after_create :deliver_email

	def deliver_email
		UserScheduleMailer.schedule_email(self).deliver
	end
end
