class ChangeRightsForDepartmentAssistants < ActiveRecord::Migration
  def self.up
    users = User.where(role: "department_assistant")
    users.each do |user|
      user.remove_role(:department_assistant)
      department_assistant = user.department_assistant
      department = department_assistant.try(:department)
      department.try(:department_blocks).each { |block| user.add_role :department_assistant, block } if department.present? && department_assistant.present?
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
