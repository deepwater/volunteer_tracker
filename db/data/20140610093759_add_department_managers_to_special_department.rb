class AddDepartmentManagersToSpecialDepartment < ActiveRecord::Migration
  def self.up
    department_managers = User.where(role: "department_manager")
    department_managers.each do |user|
      user.remove_role(:department_manager)
      department_manager = user.department_manager
      department = department_manager.try(:department)
      user.add_role :department_manager, department if department.present? && department_manager.present?
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
