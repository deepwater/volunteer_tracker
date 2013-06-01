class CheckIn < ActiveRecord::Base

	validates_uniqueness_of :user_schedule_id

	belongs_to :user_schedule
end
