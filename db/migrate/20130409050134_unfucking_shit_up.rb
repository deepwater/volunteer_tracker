class UnfuckingShitUp < ActiveRecord::Migration
	def change
	    remove_column :department_blocks, :start_time_id
	    remove_column :department_blocks, :end_time_id

	    add_column :department_blocks, :day_id, :integer
	    add_column :department_blocks, :start_time, :string
	    add_column :department_blocks, :end_time, :string

	    remove_column :user_availabilities, :day
	    remove_column :user_availabilities, :start_time
	    remove_column :user_availabilities, :end_time

	end
end
