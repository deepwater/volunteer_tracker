class UsersDatatable < AjaxDatatablesRails
  
  def initialize(view)
    @model_name = User
    @columns =  [ "users.first_name", "users.last_name" ] # insert array of column names here
    @searchable_columns = [ "users.full_name", "users.email", "users.role" ] #insert array of columns that will be searched
    super(view)
  end
  
  def paginate_records(records)
    records.offset((page - 1) * per_page).limit(per_page)
  end

private

    def data
      users.map do |user|
        [
          # comma separated list of the values for each cell of a table row
          link_to(user.full_name, admin_user_path(user)),
          user.email,
          user.tshirt_size,
          user.role,
          user.charities.any? ? user.charities.first.name : "Not assigned",
          link_to('Edit', edit_admin_user_path(user)),
          link_to('Delete', admin_user_path(user), :method => :delete, confirm: "Are you sure you want to delete this user?")
        ]
      end
    end

    def users
      @users ||= fetch_records
    end

    def get_raw_records
      # insert query here
      User.where('id>0')
    end
    
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end