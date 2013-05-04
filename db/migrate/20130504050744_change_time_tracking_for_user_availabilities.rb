class ChangeTimeTrackingForUserAvailabilities < ActiveRecord::Migration
	def change
		remove_column :user_availabilities, :time

		add_column :user_availabilities, :start_time, :text
		add_column :user_availabilities, :end_time, :text
	end
end
