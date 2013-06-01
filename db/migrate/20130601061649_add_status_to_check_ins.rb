class AddStatusToCheckIns < ActiveRecord::Migration
  def change
    add_column :check_ins, :status, :text

  end
end
