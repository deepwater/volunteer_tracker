class CreateUserAvailabilities < ActiveRecord::Migration
  def change
    create_table :user_availabilities do |t|
      t.integer :day
      t.integer :time_block
      t.integer :user_id

      t.timestamps
    end
  end
end
