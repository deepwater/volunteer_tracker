class Day < ActiveRecord::Base

	has_many :user_availabilities
	has_many :department_blocks
	has_many :user_schedules, through: :department_blocks

	# scope :user_schedules, Day.joins(:department_blocks => :model3).where('model3.label' => 'label')

	def user_scheduled?(user)
		users = []

		self.department_blocks.each do |department_block|
			department_block.users.each do |user|
				users << user
			end
		end
		users.include?(user)

	end


	def day_name
   		t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
   		return t.strftime("%a")
	end

	def short_date 
   		t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
		return t.strftime("%m/%d")
	end

	def safe_short_date 
   		t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
		return t.strftime('%m%d')
	end

	def long_date
   		t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
   		return t.strftime("%a %b %e %Y")
	end	

	def short_date_with_day
   		t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
   		return t.strftime("%a %b %e")
   	end

	def short_date_with_long_day
   		t = Time.new(self.year,self.month,self.mday, 0, 0, 0)
   		return t.strftime("%A, %B %e")
   	end
end