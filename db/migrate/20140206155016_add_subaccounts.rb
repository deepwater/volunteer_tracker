class AddSubaccounts < ActiveRecord::Migration
  def change
    add_column :users, :master_id, :integer
  end
end
