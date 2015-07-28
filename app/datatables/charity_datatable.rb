class CharityDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :admin_charity_path, :edit_admin_charity_path

  def sortable_columns
    @sortable_columns ||= [ "Charity.name" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "Charity.name" ]
  end

  def data
    records.map do |record|
      [
        link_to(record.name, admin_charity_path(record)),
        link_to('Edit', edit_admin_charity_path(record), remote: true),
        link_to('Delete', admin_charity_path(record), method: :delete, data: { confirm: 'Are you sure?' }),
        volunteer_hours_progress(record)
      ]
    end
  end

  def get_raw_records
    Charity
  end

  private

    def volunteer_hours_progress(charity)
      progress = UserSchedule.where(charity_id: charity.id)
        .joins("LEFT OUTER JOIN check_ins ON check_ins.user_schedule_id = user_schedules.id")
        .where("check_ins.status = '2'")
        .select("user_schedules.charity_id, SUM(extract(epoch from (check_ins.check_out_time - check_ins.created_at))) as total_seconds")
        .group("user_schedules.charity_id").inject({}) { |h, o| h.merge!({o.charity_id => o.total_seconds.to_i/3600}) }
      html = progress.present? ? progress : ''
      html
    end
end
