class AddDayIdToUserAvailabilities < ActiveRecord::Migration
  def change
    add_column :user_availabilities, :day_id, :integer

  end
end
