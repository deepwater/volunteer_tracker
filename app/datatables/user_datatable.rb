class UserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari
  
  def_delegators :@view, :link_to, :admin_user_path, :edit_admin_user_path

  def sortable_columns
    @sortable_columns ||= ["users.first_name", "users.email", "users.username", "users.last_sign_in_at", "users.role", "charities.name"]
  end

  def searchable_columns
    @searchable_columns ||= ["users.first_name", "users.email", "users.username", "users.role", "charities.name"]
  end

  private

  def data
    records.map do |record|
      [
        link_to(record.full_name, admin_user_path(record), id: "#{record.id}-user"),
        "#{record.email}<br>#{record.secondary_email}",
        record.username,
        record.last_sign_in_at ? record.last_sign_in_at.to_formatted_s(:long_ordinal) : "Has not been logged yet",
        record.role,
        record.charities.any? ? record.charities.first.name : "Not assigned",
        link_to('Edit', edit_admin_user_path(record)),
        link_to('Delete', admin_user_path(record), method: :delete, confirm: "Are you sure you want to delete this user?", remote: true)
      ]
    end
  end

  def get_raw_records
    User.where('users.id > 0').includes(:charities)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
