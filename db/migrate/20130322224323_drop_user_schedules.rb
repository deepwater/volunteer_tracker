class DropUserSchedules < ActiveRecord::Migration
	def change
		drop_table :user_schedules
	end
end
