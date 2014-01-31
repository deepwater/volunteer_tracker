class AddDateFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :day_of_start, :date
    add_column :events, :day_of_finish, :date
    add_column :events, :days_for_setup, :integer
    add_column :events, :days_for_tear_down, :integer
  end
end
