class UserAvailability < ActiveRecord::Base
	belongs_to :user
	belongs_to :day, primary_key: 'day_id', foreign_key: 'id'
end
