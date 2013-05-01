class CreateVolunteerManagers < ActiveRecord::Migration
  def change
    create_table :volunteer_managers do |t|
      t.integer :user_id
      t.integer :department_block_id

      t.timestamps
    end
  end
end
