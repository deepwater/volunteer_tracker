class VolunteerDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :content_tag, :edit_admin_user_path, :admin_user_path

  def sortable_columns
    @sortable_columns ||= [ "users.username" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "users.username" ]
  end

  private

  def data
    records.map do |record|
      [
        content_tag(:span, record.user.username, class: "set-class-row-to #{status_of(record)}", id: "#{record.id}-user_schedule"),
        record.user_schedule.department_block.start_time,
        record.created_at.strftime("%l:%M %p"),
        record.user_schedule.department_block.end_time,
        record.check_out_time.try(:strftime, "%b %-d %l:%M %p") || "no data",
        record.hours_worked,
        record.user_schedule.department_block.department.name,
        record.user_schedule.department_block.name,
        link_to('Edit', edit_admin_user_path(record.user))
      ]
    end
  end

  def get_raw_records
    user_ids = User.with_role(:volunteer)
                   .joins({ user_schedules: :department_block })
                   .where("department_blocks.day_id = ?", options[:day].id).pluck(:id)

    CheckIn.includes( { user_schedule: [ :charity, { department_block: :department } ] }, :user)
           .where("department_blocks.day_id = ?", options[:day].id)
           .where("check_ins.user_id IN (#{user_ids.join(',')})")
  end

  def status_of(check_in)
    user_schedule = check_in.user_schedule
    volunteer = user_schedule.user
    department_block = user_schedule.department_block
    day = department_block.day
    schedule_start_time = day.date.utc + Time.parse(department_block.start_time).seconds_since_midnight
    schedule_end_time = day.date.utc + Time.parse(department_block.end_time).seconds_since_midnight
    if check_in
      checkin_start_time = check_in.created_at.time
      checkin_end_time = check_in.check_out_time.try(:time)
    end

    status = if checkin_end_time.blank?
      "yellow"
    elsif checkin_end_time > schedule_end_time
      "red"
    elsif checkin_start_time >= schedule_start_time
      "green"
    else
      "neutral"
    end
    status
  end
end


