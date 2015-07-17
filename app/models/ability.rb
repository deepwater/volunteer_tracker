class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_any_role? :super_admin, :org_admin
      can :manage, :all
      cannot :manage_fastpass, User
    end
    if user.has_role? :event_admin
      can :manage, :all
      cannot :manage, Organisation
    end
    if user.has_role? :department_manager
      can :manage, DepartmentBlock
    end
    if user.has_role? :department_assistant
      can :manage, UserSchedule
      can :manage, CheckIn
    end
    if user.has_role? :volunteer_manager
      can :manage, CheckIn if user.check_ins.where(status: '1').exists?
      can :flag, CheckIn
    end
    if user.has_role? :volunteer
      can :read, :all
    end

    can :manage_fastpass, User do |user|
      department_condition = DepartmentManager.where(department_id: 10, user_id: user.try(:id)).exists? ||
      DepartmentAssistant.where(department_id: 10, user_id: user.try(:id)).exists? ||
      VolunteerManager.where(department_block_id: DepartmentBlock.where(department_id: 10).pluck(:id), user_id: user.try(:id)).exists?
      user.has_any_role?(:event_admin, :super_admin, :org_admin) || department_condition
    end
  end
end
