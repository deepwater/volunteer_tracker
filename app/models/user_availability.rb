class UserAvailability < ActiveRecord::Base
	belongs_to :user

	def return_day
		dayNum = 20 + self.day
		return dayNum.ordinalize + " July"
	end

	def return_time_block
		if self.time_block.even?
			hour = self.time_block.to_s + self.time_block.to_s
			time_block = "00" 
		else 
			last_hour = self.time_block--
			hour = last_hour.to_s + last_hour.to_s
			time_block = "30"
		end
		return hour + ":" + time_block
	end
end
