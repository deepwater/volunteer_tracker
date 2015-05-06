class UsersDatatable < AjaxDatatablesRails

  def initialize(view)
    @model_name = User
    @columns =  [ "users.first_name", "users.email", "users.username", "users.last_sign_in_at", "users.role",  "charities.name" ] # insert array of column names here
    @searchable_columns = [ "concat(users.first_name, ' ', users.last_name)", "users.email", "users.username", "users.role",  "charities.name" ] #insert array of columns that will be searched
    super(view)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def paginate_records(records)
    records.offset((page - 1) * per_page).limit(per_page)
  end

  private

  def data
    users.map do |user|
      [
        link_to(user.full_name, admin_user_path(user), id: "#{user.id}-user"),
        "#{user.email}<br>#{user.secondary_email}",
        user.username,
        user.last_sign_in_at ? user.last_sign_in_at.to_formatted_s(:long_ordinal) : "Has not been logged yet",
        %w[department_assistant department_manager].include?(user.role) && user.role.present? ? "#{user.role} (#{user.send(user.role).department.name})" : user.role,
        user.charities.any? ? user.charities.first.name : "Not assigned",
        link_to('Edit', edit_admin_user_path(user), remote: true),
        link_to('Delete', admin_user_path(user), method: :delete, confirm: "Are you sure you want to delete this user?", remote: true)
      ]
    end
  end

  def search_records(records)
    if params[:sSearch].present?
      query = @searchable_columns.map do |column|
        "lower(#{column}) LIKE :search"
      end.join(" OR ")
      records = records.where(query, search: "%#{params[:sSearch].to_s.downcase}%")
    end
    return records
  end


  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page).includes(:charities)
    if params[:sSearch].present?
      users = users.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    users
  end

  def users
    @users ||= fetch_records
  end

  def get_raw_records
    User.where('users.id > 0').includes(:charities)
  end

  def get_raw_record_count
    search_records(get_raw_records).count
  end
end
