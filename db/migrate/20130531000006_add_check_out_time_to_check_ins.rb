class AddCheckOutTimeToCheckIns < ActiveRecord::Migration
  def change
    add_column :check_ins, :check_out_time, :string

  end
end
