module Dashboard::TimeAvailabilitiesHelper

	def timeslots_as_json(event_time_slots)
		event_time_slots.collect do |day, time_slots|
			list_of_time_slots = []
			time_slots.each do |time_slot|
				list_of_time_slots << Time.at(time_slot.utc_date).in_time_zone.strftime("%H%M")
			end

			{
				:date => day,
				:time_slots => list_of_time_slots
			}
		end.to_json
		# logger.debug "#{Time.zone.now}"
	end
end
