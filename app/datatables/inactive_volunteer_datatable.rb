class InactiveVolunteerDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :in_twelve_hour_time, :link_to, :dashboard_check_in_path, :simple_form_for, :button, :input, :content_tag, :check_box_tag

  def sortable_columns
    @sortable_columns ||= ['User.username', 'User.first_name', 'User.email', 'Department.name',
                          'DepartmentBlock.name', 'CheckIn.created_at', 'CheckIn.created_at',
                          'CheckIn.check_out_time', 'CheckIn.check_out_time', 'CheckIn.check_out_time', 'Charity.name']
  end

  def searchable_columns
    @searchable_columns ||= ['User.username', 'User.first_name', 'User.email', 'Charity.name']
  end

  private 

  def data
    records.map do |record|
      [
        check_box_tag('check_in_ids[]', record.id, false),
        record.user_schedule.try(:user).try(:username),
        record.user_schedule.try(:user).try(:full_name) || 'User missing',
        record.user_schedule.try(:user).try(:email),
        link_to(record.user_schedule.department_block.department.name, [:dashboard, record.user_schedule.department_block.department]),
        link_to(record.user_schedule.department_block.name, [:dashboard, record.user_schedule.department_block]),
        record.created_at.strftime("%b %-d"),
        record.created_at.strftime("%l:%M%p"),
        record.check_out_time.strftime("%b %-d"),
        record.check_out_time.strftime("%l:%M%p"),
        content_tag(:div, record.hours_worked, class: 'hours-worked'),
        record.user_schedule.charity.present? ? record.user_schedule.charity.name : 'Not assigned',
        content_tag(:div, action_buttons(record), data: { record_id: record.id }, class: 'actions')
      ]
    end
  end

  def get_raw_records
    query = CheckIn
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
      query = query.where(user_schedule_id: (user_schedule_ids & day_user_schedule_ids))
    else
      query = query.where(user_schedule_id: day_user_schedule_ids)
    end

    query.where(status: '2').includes(user_schedule: [:charity, :user, { department_block: :department }])
  end

  def action_buttons(check_in)
    html = simple_form_for([:dashboard, check_in]) do |f|
      f.input(:status, as: :hidden, input_html: { value: '2' }) +
      f.button(:submit, 'Check Out', class: 'btn btn-success')
    end
    if options[:user].role != 'volunteer'
      html += link_to('Undo Check In', dashboard_check_in_path(check_in), method: :delete, class: 'btn btn-danger', style: 'margin-top:10px;')
    end
    html
  end
end
