class ChangeUserAvailabilities < ActiveRecord::Migration
  def change
  	remove_column :user_availabilities, :day
  	remove_column :user_availabilities, :time_block

  	add_column :user_availabilities, :time_slot_id, :integer
  end
end
