class TransferUserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :content_tag, :html_safe

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
        record.full_name,
        record.email,
        record.role,
        "<input type='radio' name='user[master_id]' value='#{record.id}'></input>".html_safe
      ]
    end
  end

  def get_raw_records
    User.includes(:subaccounts)
  end
end
