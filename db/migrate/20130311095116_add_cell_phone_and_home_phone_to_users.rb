class AddCellPhoneAndHomePhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cell_phone, :integer
    add_column :users, :home_phone, :integer

  end
end
