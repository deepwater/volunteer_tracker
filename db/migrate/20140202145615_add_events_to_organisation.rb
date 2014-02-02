class AddEventsToOrganisation < ActiveRecord::Migration
  def change
    add_column :events, :organisation_id, :integer
  end
end
