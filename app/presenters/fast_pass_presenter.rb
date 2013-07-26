class FastPassPresenter
  def for_json(check_in)
    return {} unless check_in
    {
      name: check_in.user.try(:full_name),
      user_schedule_id: check_in.user_schedule_id,
      hours_worked: check_in.hours_worked
    }
  end

  def errors_for_json(check_in)
    return [] unless check_in
    errors = check_in.errors.map{ |k,v| v }.flatten
  end
end