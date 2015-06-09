class CutMailtoFromSomeUsersEmail < ActiveRecord::Migration
  def self.up
    User.where("email LIKE :prefix", prefix: "mailto:%").each do |u|
      corrected_email = u.email.sub(/^mailto:/, '')
      u.skip_reconfirmation!
      u.update_attributes!(email: corrected_email)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
