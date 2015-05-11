class TransferUserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view

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
          record.role
      ]
    end
  end

  def get_raw_records
    User.all
  end
end
