require 'csv'
class Subaccounts::CsvImporter
  attr_reader :accessor, :response

  def initialize(options = {})
    @accessor = options[:as]
    @options = options
    @response = OpenStruct.new(
      successfully_created: 0,
      not_valid_rows: [],
      status: :success
    )
  end

  def import(params)
    data = params[:file].present? ? CSV.read(params[:file].path, headers: true) : hash_to_array(params[:data])
    data.each do |row|
      errors = {}
      errors[:charity] = "Charity is invalid" if Charity.find_by_name(row[7]).blank?
      errors[:abilities] = "Subaccount with no abilities" if row.slice(9, 12).compact.blank?
      user = build_from_row(row)
      user.skip_confirmation!
      if user.valid?
        if errors.blank?
          user.save
          add_charity_by_name(user, row[7])
          set_availabilities(user, row.slice(9, 12))
          response.successfully_created += 1
        end
      else
        errors.merge!(user.errors.messages)
      end
      if errors.present?
        response.not_valid_rows << { errors: errors, row: row }
        response.status = :error
      end
    end
    response
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

  def add_charity_by_name(user, charity_name)
    charity = Charity.find_by_name(charity_name)
    user.charities << charity
  end

  def set_availabilities(user, row)
    Day.all.each_with_index do |day, index|
      day.user_availabilities.create(start_time: "00:00", end_time: "23:59", user_id: user.id) if row[index].present?
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
