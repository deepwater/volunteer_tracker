class UserAvailability < ActiveRecord::Base
	belongs_to :user
	belongs_to :event_timeslot
end
