class AddCcEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secondary_email, :text

  end
end
