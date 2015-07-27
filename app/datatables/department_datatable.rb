class DepartmentDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :content_tag, :admin_department_path, :edit_admin_department_path, :admin_department_path, :get_department_usage, :get_department_usage_class

  def sortable_columns
    @sortable_columns ||= [ "Department.name" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "Department.name" ]
  end

  def data
    records.map do |record|
      [
        link_to(record.name, admin_department_path(record)),
        budgeted_hours_progress(record),
        block_scheduling_hours_progress(record),
        volunteer_hours_progress(record.id),
        link_to('Edit', edit_admin_department_path(record), remote: true),
        link_to('Delete', admin_department_path(record), method: :delete, data: { confirm: 'Are you sure?' })
      ]
    end
  end

  def get_raw_records
    query = build_query
    query = build_select(query)
    query = group_and_order(query)
    query
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: get_raw_records.count(:all).length,
      recordsFiltered: filter_records(get_raw_records).count(:all).length,
      data: data
    }
  end

  private

  def volunteer_hours_progress(department_id)
    result = CheckIn
      .where("check_ins.status = '2'")
      .where("department_blocks.department_id IN (?)", [*department_id])
      .joins("LEFT OUTER JOIN user_schedules ON user_schedules.id = check_ins.user_schedule_id")
      .joins("LEFT OUTER JOIN department_blocks ON department_blocks.id = user_schedules.department_block_id")
      .select("department_blocks.department_id, SUM(extract(epoch from (check_ins.check_out_time - check_ins.created_at))) as total_seconds")
      .group("department_blocks.department_id").inject({}){ |h, o| h.merge!({ o.department_id.to_i => o.total_seconds.to_i/3600 }) }
    result[department_id].to_i
  end

  def budgeted_hours_progress(department)
    html = content_tag :div, class: 'progress' do
      content_tag(:div, nil, class: "progress-bar #{get_department_usage_class(department.estimate_hours_total, department.budgeted_hours)}", style: "width: #{get_department_usage(department.estimate_hours_total, department.budgeted_hours)}%;")
    end
    html += "#{department.estimate_hours_total.to_i} / #{department.budgeted_hours}"
    html
  end

  def block_scheduling_hours_progress(department)
    html = content_tag :div, class: 'progress' do
      content_tag(:div, nil, class: "progress-bar #{get_department_usage_class(department.scheduled_count, department.total_slots)}", style: "width: #{get_department_usage(department.scheduled_count, department.total_slots)}%;")
    end
    html += "#{department.scheduled_count} / #{department.total_slots}"
    html
  end

  def build_query
    Department.joins("LEFT OUTER JOIN department_blocks ON department_blocks.department_id = departments.id")
  end

  def build_select(query)
    select_query = %w(departments.id departments.name departments.budgeted_hours)
    select_query << "SUM(department_blocks.suggested_number_of_workers) as total_slots"

    select_query << %Q{
      SUM(
        (extract(epoch from (cast(department_blocks.end_time as time) - interval '1 second'))
        - 
        extract(epoch from (cast(department_blocks.start_time as time))) + 1)/3600 * department_blocks.suggested_number_of_workers) as estimate_hours_total
    }

    select_query << "SUM((SELECT COUNT(DISTINCT id) FROM user_schedules WHERE department_block_id = department_blocks.id)) as scheduled_count"

    query.select select_query.join(', ')
  end

  def group_and_order(query)
    query.group("departments.id").order("departments.name")
  end
end
