class AddPendingUserIdsForTransfer < ActiveRecord::Migration
  def change
    add_column :users, :pending_master_id, :integer
    add_column :users, :transfer_status, :string
  end
end
