class RemoveAllotedHoursFromCharities < ActiveRecord::Migration
  def change
  	remove_column :charities, :alloted_hours
  end
end
