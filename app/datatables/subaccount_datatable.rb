class SubaccountDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari
  
  def_delegators :@view, :link_to, :user_user_availabilities_path, :edit_user_subaccount_path, :user_subaccount_path

  def sortable_columns
    @sortable_columns ||= [ "users.username", "users.first_name", "charities.name" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "users.username", "charities.name"]
  end

  private

  def data
    records.map do |record|
      [
        link_to(record.username, user_subaccount_path(options[:user], record), id: "#{record.id}-subaccount"),
        record.full_name,
        record.charities.first.try(:name),
        link_to('Set availabilities', user_user_availabilities_path(record)),
        link_to('Edit', edit_user_subaccount_path(options[:user], record)),
        link_to('Delete', user_subaccount_path(options[:user], record), method: :delete, confirm: "Are you sure?", remote: true)
      ]
    end
  end

  def get_raw_records
    options[:user].subaccounts.includes(:charities)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
