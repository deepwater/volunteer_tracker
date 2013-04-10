class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.integer :mday
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
