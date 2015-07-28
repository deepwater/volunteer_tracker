class VolunteerDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :content_tag, :edit_admin_user_path, :admin_user_path, :simple_form_for, :button_tag, :input

  def sortable_columns
    @sortable_columns ||= [ "User.username" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "User.username" ]
  end

  def html_row_from_record(record)
    html_row = {}
    html_row[:username]         = content_tag(:span, record.user.username, class: "set-class-row-to #{status_of(record)}", id: "#{record.id}-checkin")
    html_row[:schedule_start]   = record.user_schedule.department_block.start_time
    html_row[:checkin_start]    = record.created_at.strftime("%b %-d %l:%M %p")
    html_row[:schedule_end]     = record.user_schedule.department_block.end_time
    html_row[:checkin_end]      = record.check_out_time.try(:strftime, "%b %-d %l:%M %p") || "no data"
    html_row[:total_hours]      = record.hours_worked
    html_row[:department_name]  = record.user_schedule.department_block.department.name
    html_row[:block_name]       = record.user_schedule.department_block.name
    html_row[:actions]          = content_tag :div, class: "actions-col" do
                                    link_to('Edit', edit_admin_user_path(record.user), class: 'btn btn-primary') +
                                    simple_form_for([:dashboard, CheckIn.new], remote: true) do |f|
                                      f.input(:user_schedule_id, as: :hidden, input_html: { value: record.user_schedule.id }) +
                                      f.input(:status, as: :hidden, input_html: { value: '1' }) +
                                      button_tag('Check In', type: 'submit', class: 'btn btn-success')
                                    end +
                                    simple_form_for([:dashboard, record], remote: true) do |f|
                                      f.input(:status, as: :hidden, input_html: { value: '2' }) +
                                      button_tag('Check Out', type: 'submit', class: 'btn btn-danger')
                                    end
                                  end
    html_row
  end

  def data
    records.map do |record|
      html_row = html_row_from_record(record)
      [
        html_row[:username],
        html_row[:schedule_start],
        html_row[:checkin_start],
        html_row[:schedule_end],
        html_row[:checkin_end],
        html_row[:total_hours],
        html_row[:department_name],
        html_row[:block_name],
        html_row[:actions]
      ]
    end
  end

  def get_raw_records
    user_ids = User.with_role(:volunteer)
                   .joins({ user_schedules: :department_block })
                   .where("department_blocks.day_id = ?", options[:day].id).pluck(:id)

    scope = CheckIn.includes( { user_schedule: [ :charity, { department_block: :department } ] }, :user)
           .where("department_blocks.day_id = ?", options[:day].id)
           .where("check_ins.user_id IN (#{user_ids.join(',')})")

    spectator = options[:spectator]

    case spectator.role.to_sym
    when :department_manager
      scope = scope.where("department_blocks.id = ?", spectator.department_manager.department.department_blocks.pluck(:id))
    when :department_assistant
      scope = scope.where("department_blocks.id = ?", spectator.department_assistant.department.department_blocks.pluck(:id))
    when :volunteer_manager
      scope = scope.where("department_blocks.id = ?", [ *spectator.volunteer_manager.try(:department_block_id) ] )
    end

    scope
  end

  private

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
