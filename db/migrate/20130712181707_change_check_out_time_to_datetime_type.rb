class ChangeCheckOutTimeToDatetimeType < ActiveRecord::Migration
  def up
    remove_column :check_ins, :check_out_time
    add_column :check_ins, :check_out_time, :datetime
  end

  def down
    remove_column :check_ins, :check_out_time
    add_column :check_ins, :check_out_time, :string
  end
end
