class DeletePreviousCheckins < ActiveRecord::Migration
  def self.up
    CheckIn.delete_all
  end

  def self.down
    raise IrreversibleMigration
  end
end
