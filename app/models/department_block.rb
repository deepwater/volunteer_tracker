class DepartmentBlock < ActiveRecord::Base
	belongs_to :department
	belongs_to :event_timeslot

	has_one :start_time, :class_name =>  "EventTimeslot", :primary_key => "start_time_id", :foreign_key => "id"
	has_one :end_time, :class_name =>  "EventTimeslot", :primary_key => "end_time_id", :foreign_key => "id"
end
