class DepartmentBlocksService
  class ShowActionData
    attr_accessor :department_block, :user_schedules, :volunteer_managers,
                  :user_availabilities, :user_availabilities_count, :scope
  end

  def prepare_data_for_show_action(user, scope)
    data = ShowActionData.new

    data.scope                = scope
    data.department_block     = find_department_block(scope.id)
    data.user_schedules       = find_user_schedules(data)
    data.volunteer_managers   = find_volunteer_managers(data)

    repo = UserAvailabilityRepository.new
    data.user_availabilities = repo.find_list_of_availabilities_for_department_block(data.department_block, scope)
    data.user_availabilities_count  = repo.user_availabilities_count(
      data.department_block, scope
    )

    data
  end

  private

  def find_department_block(id)
    DepartmentBlock.includes(
      :users, :day, :department, volunteer_managers: :user
    ).find(id)
  end

  def find_user_schedules(data)
    user_ids = data.department_block.users.map(&:id)
    user_schedules = UserSchedule.includes(:user).where(
      department_block_id: data.department_block.id, user_id: user_ids
    ).to_a if user_ids.present?
    Array.wrap(user_schedules).inject({}) do |result, user_schedule|
      result[user_schedule.user_id] = user_schedule
      result
    end
  end

  def find_volunteer_managers(data)
    user_ids = data.department_block.volunteer_managers.map(&:user_id)
    volunteer_managers = VolunteerManager.where(
      department_block_id: data.department_block.id,
      user_id: user_ids
    ).to_a if user_ids.present?
    Array.wrap(volunteer_managers).inject({}) do |result, volunteer_manager|
      result[volunteer_manager.user_id] = volunteer_manager
      result
    end
  end
end
