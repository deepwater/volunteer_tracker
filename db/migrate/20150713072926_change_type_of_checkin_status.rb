class ChangeTypeOfCheckinStatus < ActiveRecord::Migration
  def change
    change_column :check_ins, :status, :string
  end
end
