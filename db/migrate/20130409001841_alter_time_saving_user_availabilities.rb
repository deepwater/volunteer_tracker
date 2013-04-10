class AlterTimeSavingUserAvailabilities < ActiveRecord::Migration
  def change
    remove_column :user_availabilities, :event_timeslot_id

    add_column :user_availabilities, :start_time, :string
    add_column :user_availabilities, :end_time, :string
  end
end
