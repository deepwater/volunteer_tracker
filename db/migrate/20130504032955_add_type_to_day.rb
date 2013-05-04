class AddTypeToDay < ActiveRecord::Migration
  def change
    add_column :days, :type, :integer

  end
end
