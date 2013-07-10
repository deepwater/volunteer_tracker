class UserAvailabilityRepository
  def find_list_of_availabilities_for_department_block(department_block, scope)
    user_availabilities_criteria(department_block, scope).page(scope.page).per(scope.per_page).to_a
  end

  def user_availabilities_count(department_block, scope)
    count = user_availabilities_criteria(department_block, scope).count
  end

  private

  def user_availabilities_criteria(department_block, scope)
    user_ids = UserAvailability.joins(:user).where(
      day_id: department_block.day_id
    ).where(
      "users.role != 'department_manager' AND users.role != 'event_administrator'"
    ).group(:user_id).pluck(:user_id)

    UserAvailability.where(user_id: user_ids).where(
      day_id: department_block.day_id
    ).includes(
      user: :charities,
      day: {user_schedules: :department_block}
    ).joins(
      "left outer join user_schedules on user_schedules.user_id = user_availabilities.user_id"
    ).joins(
      "left outer join department_blocks as user_schedule_department_blocks on user_schedules.department_block_id = user_schedule_department_blocks.id"
    ).where(
      "(user_schedule_department_blocks.day_id is null OR user_schedule_department_blocks.day_id = #{department_block.day_id})"
    ).where(
      "(user_schedules.department_block_id is null or user_schedules.department_block_id != #{department_block.id})"
    ).where(
      overlaps_criteria_for_user_availabilities(department_block)
    )
  end

  def overlaps_criteria_for_user_availabilities(department_block)
    dep_block_start = "time '#{department_block.start_time}'"
    dep_block_end = "time '#{department_block.end_time}' - interval '1 second'"

    other_dep_block_start = "cast(user_availabilities.start_time as time)"
    other_dep_block_end = "cast(user_availabilities.end_time as time) - interval '1 second'"
    %Q(
      (#{dep_block_start}, #{dep_block_end}) overlaps (#{other_dep_block_start}, #{other_dep_block_end})
    )
  end
end
