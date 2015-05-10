class BecomeUserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :dashboard_become_user_path

  def sortable_columns
    @sortable_columns ||= ["User.first_name", "User.email", "User.username", "User.role"]
  end

  def searchable_columns
    @searchable_columns ||= ["User.first_name", "User.email", "User.username", "User.role"]
  end

  private

  def data
    records.map do |record|
      [
          link_to(record.full_name, dashboard_become_user_path(record)),
          record.email,
          record.username,
          record.role
      ]
    end
  end

  def get_raw_records
    User.where("role = ? OR role = ? or role = ?", :volunteer, :volunteer_manager, :department_assistant)
  end
end
