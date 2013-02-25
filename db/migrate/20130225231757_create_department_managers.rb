class CreateDepartmentManagers < ActiveRecord::Migration
  def change
    create_table :department_managers do |t|
      t.integer :user_id
      t.integer :department_id

      t.timestamps
    end
  end
end
