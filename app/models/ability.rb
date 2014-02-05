class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :super_admin
      can :manage, :all
    else
      can :read, :all
    end

    if user.role? :volunteer
    end
    if user.role? :volunteer_manager
      can :manage, CheckIn if user.check_ins.where(status: "1").exists?
      can :flag, CheckIn
    end
    if user.role? :department_assistant
      can :manage, UserSchedule
      can :manage, CheckIn
    end
    if user.role? :department_manager
      can :manage, DepartmentBlock
    end
    if user.role? :event_administrator
      can :manage, :all
    end

    can :manage_fastpass, User do |u|
      department_condition = DepartmentManager.where(department_id: 10, user_id: user.try(:id)).exists? ||
      DepartmentAssistant.where(department_id: 10, user_id: user.try(:id)).exists? ||
      VolunteerManager.where(department_block_id: DepartmentBlock.where(department_id: 10).pluck(:id), user_id: user.try(:id)).exists?
      user.role?(:event_administrator) || department_condition
    end
  end
end
