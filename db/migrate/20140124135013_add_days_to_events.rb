class AddDaysToEvents < ActiveRecord::Migration
  def change
    add_column :days, :event_id, :integer

  end
end
