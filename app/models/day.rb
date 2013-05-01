# == Schema Information
#
# Table name: days
#
#  id         :integer          not null, primary key
#  mday       :integer
#  month      :integer
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Day < ActiveRecord::Base

	has_many :user_availabilities
	has_many :department_blocks

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
end
