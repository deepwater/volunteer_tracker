class DeleteUserAvailabilities < ActiveRecord::Migration
  def self.up
    UserAvailability.delete_all
  end

  def self.down
    raise IrreversibleMigration
  end
end
