class CheckIn < ActiveRecord::Base

	validates_uniqueness_of :user_schedule_id
	belongs_to :user_schedule
	belongs_to :user

	before_save :check_status

	has_many :flags

  private

	def check_status
		if (self.status_changed? && self.status == "2")
			self.check_out_time =  DateTime.now
		end
	end
end	
