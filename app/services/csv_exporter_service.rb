require 'csv'

class CsvExporterService
  attr_reader :settings

  def export(name, data)
    @settings = CSV_EXPORT_SETTINGS[name.to_s]
    data = data.try(:decorate)
    results = CSV.generate col_sep: ',' do |csv|
      csv << column_names(name)
      data.each do |row|
        csv << settings["fields"].map { |field| row.send(field) }
      end
    end
  end

  def filename
    "#{settings['filename']}-#{DateTime.now}.csv"
  end

  private

  def column_names(name)
    settings["fields"].map do |field|
      I18n.t("csv.export.#{name}.#{field}")
    end
  end
end