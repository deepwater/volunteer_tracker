class AlterTimeSavingDepartmentBlocks < ActiveRecord::Migration
  def change
    remove_column :user_availabilities, :start_time_id
    remove_column :user_availabilities, :end_time_id

    add_column :user_availabilities, :day, :string
    add_column :user_availabilities, :start_time, :string
    add_column :user_availabilities, :end_time, :string
  end
end
