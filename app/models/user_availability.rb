class UserAvailability < ActiveRecord::Base
	belongs_to :user
	has_one :day, primary_key: 'day_id', foreign_key: 'id'
end
