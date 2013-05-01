class ChangeUserAvailabilitiesAgain < ActiveRecord::Migration
  def change
  	remove_column :user_availabilities, :time_slot_id
  	add_column :user_availabilities, :event_timeslot_id, :integer
  end
end
