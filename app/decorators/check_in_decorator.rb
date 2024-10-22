class CheckInDecorator < Draper::Decorator
  delegate_all

  def full_name
    user_schedule.try(:user).try(:full_name) || "User Missing"
  end

  def email
    user_schedule.try(:user).try(:email)
  end

  def department
    user_schedule.try(:department_block).try(:department).try(:name)
  end

  def department_block
    user_schedule.try(:department_block).try(:name)
  end

  def check_date
    object.created_at.strftime("%Y-%m-%d")
  end

  def check_in_time
    object.created_at.strftime("%l:%M%p")
  end

  def check_out_date
    object.check_out_time.strftime("%Y-%m-%d")
  end

  def check_out_time
    object.check_out_time.strftime("%l:%M%p")
  end

  def charity
    check_in.user_schedule.try(:charity).try(:name) || "Not Assigned"
  end

  def hours_worked
    if object.status == "2"
      seconds = (object.check_out_time - object.created_at).to_i
      hours = seconds / 3600
      minutes = (seconds - hours * 3600) / 60
      "%02d:" % hours + "%02d" % minutes
    end
  end
end