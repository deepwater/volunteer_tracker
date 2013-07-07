class Flag < ActiveRecord::Base
	attr_accessible :check_in_id, :description, :user_id

	belongs_to :check_in
	belongs_to :user
	after_create :deliver_email

	def deliver_email
		FlagMailer.flag_email(self).deliver
	end
end
