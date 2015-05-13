class VolunteerDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :content_tag, :edit_admin_user_path, :admin_user_path

  def sortable_columns
    @sortable_columns ||= [ "User.first_name", "User.email", "User.tshirt_size", "User.role",  "Charity.name" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "User.email", "User.tshirt_size", "User.role",  "Charity.name" ]
  end

  private

  def data
    records.map do |record|
      [
        content_tag(:div, record.full_name, class: 'dropdown-wrapper', id: "#{record.id}-volunteer"),
        "#{record.email}<br>#{record.secondary_email}",
        record.tshirt_size,
        record.role,
        record.charities.any? ? record.charities.first.name : "Not assigned",
        link_to('Edit', edit_admin_user_path(record)),
        link_to('Delete', admin_user_path(record), method: :delete, confirm: "Are you sure you want to delete this volunteer?", remote: true)
      ]
    end
  end

  def get_raw_records
    User.with_role(:volunteer).includes(:charities)
  end
end
