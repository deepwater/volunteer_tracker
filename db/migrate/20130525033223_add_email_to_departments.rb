class AddEmailToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :email, :text

  end
end
