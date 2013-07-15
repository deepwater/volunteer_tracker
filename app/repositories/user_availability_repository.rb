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

    scheduled_user_ids = UserSchedule.where(department_block_id: department_block.id).pluck(:user_id)

    criteria = UserAvailability.where(user_id: user_ids).where(
      day_id: department_block.day_id
    ).includes(
      user: :charities
    ).where(
      overlaps_criteria_for_user_availabilities(department_block)
    )

    if scheduled_user_ids.present?
      criteria = criteria.where(
        "user_availabilities.user_id NOT IN (#{scheduled_user_ids.join(',')})"
      )
    end

    if scope.order_charity.present? && valid_order?(scope.order_charity)
      criteria = criteria.order("charities.name #{scope.order_charity}")
    end

    if scope.order_name.present? && valid_order?(scope.order_name)
      criteria = criteria.order("concat(users.first_name, users.last_name) #{scope.order_name}")
    end

    if scope.order_email.present? && valid_order?(scope.order_email)
      criteria = criteria.order("users.email #{scope.order_email}")
    end

    if scope.order_role.present? && valid_order?(scope.order_role)
      criteria = criteria.order("users.role #{scope.order_role}")
    end

    if scope.charity.present?
      criteria = criteria.where("charities.id = ?", scope.charity)
    end

    if scope.role.present?
      criteria = criteria.where("users.role = ?", scope.role)
    end

    if scope.q.present?
      criteria = criteria.where(
        "concat(lower(users.first_name), ' ', lower(users.last_name)) LIKE ? OR users.email LIKE ?",
        "%#{scope.q.to_s.downcase}%",
        "%#{scope.q.to_s.downcase}%"
      )
    end

    criteria
  end

  def valid_order?(direction)
    %w[asc desc].include?(direction)
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
