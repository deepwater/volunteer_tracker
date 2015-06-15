require 'roo'
class Subaccounts::Importer
  attr_reader :accessor, :response

  def initialize(options = {})
    @accessor = options[:as]
    @response = OpenStruct.new(
      created_count: 0,
      errors: [],
      not_valid_rows: []
    )
  end

  def import(params)
    data = get_data(params)
    data.each { |row| process_data_row(row) } if response.errors.blank?
    response
  end

  private

  def get_data(params)
    if params[:data].present?
      hash_to_array(params[:data])
    elsif params[:file].present?
      extension = File.extname(params[:file].original_filename).gsub('.','')
      if extension.in?(%w(csv xls xlsx))
        csv = Roo::Spreadsheet.open(params[:file].path, extension: extension).sheet(0).to_csv
        CSV.parse(csv).drop(1)
      else
        response.errors << "Wrong file type: #{params[:file].original_filename}"
      end
    else
      response.errors << 'File was not uploaded'
    end
  end

  def process_data_row(row)
    errors = {}
    errors[:charity] = 'Charity is invalid' if Charity.find_by_name(row[7]).blank?
    errors[:abilities] = 'Subaccount with no availabilities' if row.slice(9, 12).try(:compact).blank?
    row = prepare_pow!(row)
    user = build_from_row(row)
    user.skip_confirmation!
    if user.valid?
      if errors.blank?
        user.save
        add_charity_by_name(user, row[7])
        set_availabilities(user, row.slice(9, 12))
        response.created_count += 1
      end
    else
      errors.merge!(user.errors.messages)
    end
    if errors.present?
      response.not_valid_rows << { errors: errors, row: row }
    end
  end

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

  def prepare_pow!(row)
    row[5].sub!(/^mailto:/, '') if row[5].present?
    row
  end

  def add_charity_by_name(user, charity_name)
    charity = Charity.find_by_name(charity_name)
    user.charities << charity
  end

  def set_availabilities(user, row)
    Day.all.each_with_index do |day, index|
      day.user_availabilities.create(start_time: '00:00', end_time: '23:59', user_id: user.id) if row[index].present?
    end
  end

  def hash_to_array(h)
    result = []
    h.values.each do |row|
      result << (0..20).collect{|v| row[v.to_s] || nil}
    end
    result
  end

end
