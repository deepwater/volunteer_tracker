class VolunteersDatatable < AjaxDatatablesRails
  
  def initialize(view)
    @model_name = User
    @columns =  [ "users.first_name", "users.email", "users.tshirt_size", "users.role",  "charities.name" ]
    @searchable_columns = [ "concat(users.first_name, ' ', users.last_name)", "users.email", "users.tshirt_size", "users.role",  "charities.name"]
    super(view)
  end

  private

  def data
    volunteers.map do |volunteer|
      [
        content_tag(:div, volunteer.full_name, class: 'dropdown-wrapper', id: "#{volunteer.id}-volunteer"),
        "#{volunteer.email}<br>#{volunteer.secondary_email}",
        volunteer.tshirt_size,
        volunteer.role,
        volunteer.charities.any? ? volunteer.charities.first.name : "Not assigned",
        link_to('Edit', edit_admin_user_path(volunteer)),
        link_to('Delete', admin_user_path(volunteer), method: :delete, confirm: "Are you sure you want to delete this volunteer?", remote: true)
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


  def fetch_volunteers
    volunteers = User.with_role(:volunteer).order("#{sort_column} #{sort_direction}").includes(:charities)
    if params[:sSearch].present?
      volunteers = volunteers.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    volunteers
  end

  def volunteers
    @volunteers ||= fetch_records
  end

  def get_raw_records
    User.with_role(:volunteer).includes(:charities)
  end
  
  def get_raw_record_count
    search_records(get_raw_records).count
  end
end