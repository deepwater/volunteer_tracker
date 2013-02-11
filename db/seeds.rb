# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

start_date = 1374393600
end_date = 1375419600

current = start_date

interval = 1800

results = []

until current > end_date do
	# results << current
	EventTimeslot.create({:utc_date => current})

	current += interval
end
