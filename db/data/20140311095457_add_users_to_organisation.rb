class AddUsersToOrganisation < ActiveRecord::Migration
  def self.up
    User.update_all(organisation_id: Organisation.first.id) if Organisation.first.present?
  end

  def self.down
    raise IrreversibleMigration
  end
end
