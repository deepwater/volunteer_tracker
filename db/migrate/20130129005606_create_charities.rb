class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.integer :alloted_hours

      t.timestamps
    end
  end
end
