class CreateUserCharities < ActiveRecord::Migration
  def change
    create_table :user_charities do |t|
      t.integer :user_id
      t.integer :charity_id

      t.timestamps
    end
  end
end
