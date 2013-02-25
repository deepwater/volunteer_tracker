class CreateDepartmentBlocks < ActiveRecord::Migration
  def change
    create_table :department_blocks do |t|
      t.integer :start_time_id
      t.integer :end_time_id
      t.integer :suggested_number_of_workers

      t.timestamps
    end
  end
end
