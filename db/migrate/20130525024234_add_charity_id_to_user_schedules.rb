class AddCharityIdToUserSchedules < ActiveRecord::Migration
  def change
    add_column :user_schedules, :charity_id, :integer

  end
end
