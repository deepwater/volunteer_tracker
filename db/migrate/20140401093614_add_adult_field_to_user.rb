class AddAdultFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :adult, :boolean, default: true
  end
end
