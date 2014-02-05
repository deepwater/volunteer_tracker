class Role < ActiveRecord::Base
  ROLES = %w(volunteer volunteer_assistant volunteer_manager department_assistant department_manager
            event_admin org_admin super_admin)

  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :name, inclusion: ROLES
  scopify
  # attr_accessible :title, :body
end
