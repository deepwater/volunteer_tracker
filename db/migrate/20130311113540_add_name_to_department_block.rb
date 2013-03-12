class AddNameToDepartmentBlock < ActiveRecord::Migration
  def change
    add_column :department_blocks, :name, :text

  end
end
