class AllowNullInTshirtColumn < ActiveRecord::Migration
  def change
    change_column :users, :tshirt_size, :string, null: true
  end

  def down
  end
end
