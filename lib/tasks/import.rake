require 'csv'

desc "Import Charities from csv file"
task :import => [:environment] do

  file = "db/charities.csv"

  CSV.foreach(file, :headers => false) do |row|
    Charity.create({
      :name => row[0],
      :alloted_hours => 0
    })
  end

end