class TransferUserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :content_tag

  def sortable_columns
    @sortable_columns ||= ["User.first_name", "User.email", "User.role"]
  end

  def searchable_columns
    @searchable_columns ||= ["User.first_name", "User.email", "User.role"]
  end

  private

  def data
    records.map do |record|
      [
          content_tag(:div, record.full_name, id: "user_#{record.id}"),
          record.email,
          record.role
      ]
    end
  end

  def get_raw_records
    User.includes(:subaccounts)
  end
end
