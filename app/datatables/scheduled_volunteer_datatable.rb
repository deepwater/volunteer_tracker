class ScheduledVolunteerDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :in_twelve_hour_time, :link_to, :simple_form_for, :button, :input, :content_tag, :check_box_tag

  def sortable_columns
    @sortable_columns ||= ['DepartmentBlock.start_time', 'DepartmentBlock.end_time', 
                          'User.username', 'User.first_name', 'User.email',
                          'Department.name', 'DepartmentBlock.name', 'Charity.name']
  end

  def searchable_columns
    @searchable_columns ||= ['User.username', 'User.first_name', 'User.email', 'Charity.name']
  end

  private 

  def data
    records.map do |record|
      [
        check_box_tag('user_schedule_ids[]', record.id, false),
        in_twelve_hour_time(record.department_block.start_time),
        in_twelve_hour_time(record.department_block.end_time),
        record.try(:user).try(:username),
        record.try(:user).try(:full_name) || 'User missing',
        record.try(:user).try(:email),
        link_to(record.department_block.department.name, [:dashboard, record.department_block.department]),
        link_to("#{record.department_block.name}", [:dashboard, record.department_block]),
        record.charity.present? ? record.charity.name : 'Not assigned',
        content_tag(:div, action_buttons(record), data: { record_id: record.id }, class: 'actions')
      ]
    end
  end

  def get_raw_records
    query = UserSchedule
    accessor = options[:user]
    day = options[:day]

    department_block_ids = case accessor.role.to_sym
      when :department_manager then DepartmentBlock.where(department_id: accessor.department_manager.try(:department_id)).pluck(:id)
      when :department_assistant then DepartmentBlock.where(department_id: accessor.department_assistant.try(:department_id)).pluck(:id)
      when :volunteer_manager then [*accessor.volunteer_manager.try(:department_block_id)]
    end

    if day
      day_department_block_ids = DepartmentBlock.where(day_id: day.id).pluck(:id)
      day_user_schedule_ids = UserSchedule.where(department_block_id: day_department_block_ids).pluck(:id)
    end

    if department_block_ids
      user_schedule_ids = UserSchedule.where(department_block_id: department_block_ids).pluck(:id)
      query = query.where(id: (user_schedule_ids & day_user_schedule_ids))
    else
      query = query.where(id: day_user_schedule_ids)
    end

    query.group(
      "department_blocks.id, days.id, departments.id, users.id, charities.id, user_schedules.id"
    ).joins(
      "LEFT OUTER JOIN check_ins ON check_ins.user_schedule_id = user_schedules.id"
    ).having(
      "COUNT(check_ins.*) = 0"
    )

    query.includes(:charity, :user, department_block: [:day, :department])
  end

  def action_buttons(check_in)
    simple_form_for([:dashboard, CheckIn.new]) do |f|
      f.input(:user_schedule_id, as: :hidden, input_html: { value: check_in.id }) +
      f.input(:status, as: :hidden, input_html: { value: '1' }) +
      f.button(:submit, 'Check In', class: 'btn btn-success')
    end
  end
end
