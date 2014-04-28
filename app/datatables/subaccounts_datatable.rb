class SubaccountsDatatable < AjaxDatatablesRails
  
  def initialize(view)
    @model_name = User
    @columns =  [ "users.username", "users.first_name", "charities.name" ]
    @searchable_columns = [ "users.username", "concat(users.first_name, ' ', users.last_name)", "charities.name"]
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
    subaccounts.map do |subaccount|
      [
        link_to(subaccount.username, user_subaccount_path(current_user, subaccount), id: "#{subaccount.id}-subaccount"),
        subaccount.full_name,
        subaccount.charities.first.try(:name),
        link_to('Set availabilities', user_user_availabilities_path(subaccount)),
        link_to('Edit', edit_user_subaccount_path(current_user, subaccount)),
        link_to('Delete', user_subaccount_path(current_user, subaccount), method: :delete, confirm: "Are you sure?", remote: true)
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


  def fetch_subaccounts
    subaccounts = current_user.subaccounts.order("#{sort_column} #{sort_direction}")
    subaccounts = subaccounts.page(page).per_page(per_page).includes(:charities)
    if params[:sSearch].present?
      subaccounts = subaccounts.where("name like :search", search: "%#{params[:sSearch]}%")
    end
    subaccounts
  end

  def subaccounts
    @subaccounts ||= fetch_records
  end

  def get_raw_records
    current_user.subaccounts.includes(:charities)
  end
  
  def get_raw_record_count
    search_records(get_raw_records).count
  end
end