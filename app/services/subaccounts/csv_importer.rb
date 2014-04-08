require 'csv'
class Subaccounts::CsvImporter
  attr_reader :accessor

  def initialize(options = {})
    @accessor = options[:as]
    @options = options
  end

  def import(file)
    success_count, errors, csv, error_type = 0, {}, [], :standart
    if file.blank?
      errors["CSV errors"] = ["File not uploaded"]
      error_type = :fatal
    else
      CSV.foreach(file.path, headers: false) do |row|
        csv << row
        next if row[21].present? # "discard" column
        errors[row[2]] ||= [] and errors[row[2]] << "Charity is invalid" if Charity.find_by_name(row[7]).blank?
        errors[row[2]] ||= [] and errors[row[2]] << "Subaccount with no abilities" if row.slice(9, 12).compact.blank?
        if errors[row[2]].present?
          csv.last.concat [nil, true, errors[row[2]].join(', ')]
          next
        end
        user = build_from_row(row)
        user.skip_confirmation!
        if user.save
          csv.last << true
          success_count += 1
          add_charity_by_name(user, row[7])
          set_availabilities(user, row.slice(9, 12))
        else
          errors[row[2]] = user.errors.full_messages
          csv.last.concat [nil, true, user.errors.full_messages.join(', ')]
        end
      end
    end
    create_csv_with_errors(csv) if errors.present?

    { true  => { status: :success, subaccount_count: success_count },
      false => { status: :error, errors: errors, error_type: error_type }
    }[errors.blank?]
  end

  private

  def build_from_row(row)
    User.new({
      first_name: row[0],
      last_name: row[1],
      username: row[2],
      cell_phone: row[3],
      home_phone: row[4],
      email: row[5],
      tshirt_size: row[6],
      adult: row[8].present?,
      master_id: accessor.id,
      organisation_id: Organisation.first.try(:id)
    })
  end

  def create_csv_with_errors(csv)
    path = "public/system/csv/#{accessor.id}/"
    FileUtils.mkdir_p(path) unless File.directory?(path)

    CSV.open(path + "subaccounts.csv", "w") do |file|
      csv.each do |c|
        file << c
      end
    end
  end

  def add_charity_by_name(user, charity_name)
    charity = Charity.find_by_name(charity_name)
    user.charities << charity
  end

  def set_availabilities(user, row)
    Day.all.each_with_index do |day, index|
      day.user_availabilities.create(start_time: "00:00", end_time: "23:59", user_id: user.id) if row[index].present?
    end
  end

end
