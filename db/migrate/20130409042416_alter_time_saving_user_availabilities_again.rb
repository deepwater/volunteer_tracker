class AlterTimeSavingUserAvailabilitiesAgain < ActiveRecord::Migration
  def change
    remove_column :user_availabilities, :start_time
    remove_column :user_availabilities, :end_time

    add_column :user_availabilities, :time, :string
  end
end
