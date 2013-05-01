class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :department_manager_id
      t.text :name
      t.integer :budgeted_hours

      t.timestamps
    end
  end
end
