require 'csv'

desc "Import Departments from csv file"
task :import => [:environment] do

  file = "db/departments.csv"

  CSV.foreach(file, :headers => false) do |row|
    Department.create({
      :name => row[0],
      :budgeted_hours => row[1]
    })
  end

end