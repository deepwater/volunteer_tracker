class CreateCheckIns < ActiveRecord::Migration
  def change
    create_table :check_ins do |t|
      t.integer :user_schedule_id
      t.integer :user_id

      t.timestamps
    end
  end
end
