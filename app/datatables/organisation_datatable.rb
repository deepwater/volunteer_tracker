class OrganisationDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :admin_organisation_path, :edit_admin_organisation_path

  def sortable_columns
    @sortable_columns ||= [ "Organisation.name" ]
  end

  def searchable_columns
    @searchable_columns ||= [ "Organisation.name" ]
  end

  def data
    records.map do |record|
      [
        link_to(record.name, admin_organisation_path(record)),
        link_to('Edit', edit_admin_organisation_path(record), remote: true),
        link_to('Delete', admin_organisation_path(record), method: :delete, data: { confirm: 'Are you sure?' })
      ]
    end
  end

  def get_raw_records
    Organisation
  end
end
