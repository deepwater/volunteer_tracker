class AddDepartmentIdToDepartmentBlocks < ActiveRecord::Migration
  def change
    add_column :department_blocks, :department_id, :integer

  end
end
