class AddIndexesToUsersName < ActiveRecord::Migration
  def change
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, [:first_name, :last_name]
  end
end
