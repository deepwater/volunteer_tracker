class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :check_in_id
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
