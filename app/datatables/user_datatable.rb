class UserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari
  
  def_delegators :@view, :link_to, :admin_user_path, :edit_admin_user_path

  def sortable_columns
    @sortable_columns ||= ["User.first_name", "User.email", "User.username", "User.last_sign_in_at", "User.role", "Charity.name"]
  end

  def searchable_columns
    @searchable_columns ||= ["User.first_name", "User.last_name", "User.email", "User.username", "User.role", "Charity.name"]
  end

  def data
    records.map do |record|
      [
        link_to(record.full_name, admin_user_path(record), id: "#{record.id}-user"),
        "#{record.email}<br>#{record.secondary_email}",
        record.username,
        record.last_sign_in_at ? record.last_sign_in_at.to_formatted_s(:long_ordinal) : "Has not been logged yet",
        %w[department_assistant department_manager].include?(record.role) ? user_role_with_department_name(record) : record.role,
        record.charities.any? ? record.charities.first.try(:name) : "Not assigned",
        link_to('Edit', edit_admin_user_path(record), remote: true),
        link_to('Delete', admin_user_path(record), remote: true, method: :delete, data: { confirm: "Are you sure you want to delete this user?" })
      ]
    end
  end

  def get_raw_records
    User.includes(:charities)
  end

  private

    def user_role_with_department_name(user)
      if user.send(user.role).try(:department).present?
        "#{user.role} (#{user.send(user.role).department.name})"
      else
        "#{user.role} (Not assigned to any department)"
      end
    end
end
