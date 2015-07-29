class EventDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :admin_event_path, :edit_admin_event_path

  def sortable_columns
    @sortable_columns ||= [ "Event.name" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "Event.name" ]
  end

  def data
    records.map do |record|
      [
        link_to(record.name, admin_event_path(record)),
        link_to('Edit', edit_admin_event_path(record), remote: true),
        link_to('Delete', admin_event_path(record), method: :delete, data: { confirm: 'Are you sure?' })
      ]
    end
  end

  def get_raw_records
    Event
  end
end
