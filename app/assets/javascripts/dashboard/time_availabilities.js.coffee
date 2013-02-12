# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->	
	# Holds all the day objects
	availabilityList = []

	# Keeps track of the current day
	dayListIndex = 0;

	# Day Object
	class Day
		constructor: (@dayName,@timeSlots) ->
			@allDay = 0
			@availableTimes = []	
			@index = dayListIndex

		addAvailability: (dayIndex) ->
			@availableTimes.push(dayIndex);

		removeAvailability: (dayIndex) ->
			@availableTimes.splice(@availableTimes.indexOf(dayIndex), 1);

		resetAvailabilities: ->
			@availableTimes.length = 0

		saveDay: ->
			if @availableTimes.length > 0
				$.post '/dashboard/time_availabilities',
					dataType: 'json' 
					data: {
						day: @index
						availableTimes: @availableTimes
					}
					error: (jqXHR, textStatus, errorThrown) ->

					success: (data, textStatus, jqXHR) ->

	fetchDays = ->
		$.get '/dashboard/time_availabilities/get_time_slots', (data) ->

			$.each data, (i) ->	
				# Creates a New Day Object

				newDay = new Day(data[i].date, data[i].time_slots)

				# Adds the new day object to the list of available days
				availabilityList.push(newDay)
			
			# Shows the day
			showDay()

	showDay = ->
		# Changes the name of the day in the pagination
		$('.time-availability-wrapper .pagination .active a').html(availabilityList[dayListIndex].dayName)
		
		# Gets the list of time slots that are available for that day
		time_slots = availabilityList[dayListIndex].timeSlots

		if time_slots.length > 0
			$('.time-availability-wrapper tr').remove()
			$.each time_slots, (i) ->	
				$('#time-availability').append('<tr><th class="span1">' + time_slots[i] + '</th><td class="span1"></td>')

		# Checks for slots the user is already available for on new day
		listOfTimes = availabilityList[dayListIndex].availableTimes

		# If the user is available for time slots then display them all
		if listOfTimes.length > 0
			$.each listOfTimes, (i) ->	
				$('.time-availability-wrapper tr').eq(listOfTimes[i]).addClass 'success'

	switchAvailabilityButton = ->
		# Find the button element
		$el = $('.available-all-day')

		# Switch the button classes
		$el.toggleClass 'btn-primary'
		$el.toggleClass 'btn-warning'

		# Add the right text and icon for the button
		if $el.hasClass('btn-warning')
			$el.html("<i class='icon-remove-sign icon-white'></i> I'm Not Available Today");
		else
			$el.html("<i class='icon-ok-sign icon-white'></i> I'm Available All Day");

	checkAllDay = ->
		# Check if the user can do the whole day so that the button can be changed
		if availabilityList[dayListIndex].allDay == 0 
			$('.available-all-day').addClass('btn-warning').removeClass 'btn-primary'
			switchAvailabilityButton()
		else
			$('.available-all-day').removeClass('btn-warning').addClass 'btn-primary'
			switchAvailabilityButton()

	# Fetches all the days from the DB
	fetchDays()
	
	# Used for mouse interactions when dragging across time slots
	isMouseDown = false
	isHighlighted = 0

	# Event handlers for time slot selection
	$('#time-availability')
		.on 'mousedown', 'td', ->
			isMouseDown = true

			# Select the parent
			$parent = $(@).parent()

			$parent.toggleClass 'success'
			isHighlighted = $parent.hasClass 'success'

			# If the user highlighted the cell then add the index of the row to the day object as an available time
			if isHighlighted then availabilityList[dayListIndex].addAvailability($parent.index()) else availabilityList[dayListIndex].removeAvailability($parent.index())
			
			# Stop default action: highlighting text
			return false
		.on 'mouseover', 'td', ->
			# Check if the user is dragging
			if isMouseDown
				# Select the parent
				$parent = $(@).parent()

				# If the user highlighted the cell then add the index of the row to the day object as an available time
				if isHighlighted then availabilityList[dayListIndex].addAvailability($parent.index()) else availabilityList[dayListIndex].removeAvailability($parent.index())
				
				# Toggle the class based on whether the user is highlighting or unhighlighting cells
				$parent.toggleClass('success', isHighlighted)
		.bind 'selectstart', ->
			# Stop the selecting of text
			return false

	$(document)
		.mouseup ->
			isMouseDown = false;

	# Click handler for next button
	$('.next-day').on 'click', ->
		# If there are no allocated time slots then show the modal
		if $('tr.success').length == 0 then $('#confirmNextDay').modal() else navigateToNextDay()

	$('#confirmNextDay .btn-danger, #confirmNextDay .close').on 'click', ->
		navigateToNextDay()


	navigateToNextDay = ->
		# Save copy of the next button
		$el = $('.next-day')

		# If the user goes to the next day, activate previous button
		$('.prev-day').parent().removeClass 'disabled'

		# Make sure that there is actually a next day to go to
		if !$el.parent().hasClass 'disabled'

			# Clear the timetable
			$('tr.success').removeClass 'success'

			# Save the day
			availabilityList[dayListIndex].saveDay()

			# Incremement the index so that we can go to the next day
			if dayListIndex+1 <= availabilityList.length
				dayListIndex++

			# If there are no more days after this, disable the next button
			if dayListIndex == availabilityList.length-1
				$el.parent().addClass 'disabled'	

			# Show the day
			showDay()

			# Check if the user has said they can do all day for the new day
			checkAllDay()


	$('.prev-day').on 'click', ->
		# If the user goes to the previous day, activate next button
		$('.next-day').parent().removeClass 'disabled'

		# Make sure that there is actually a previous day to go to
		if !$(@).parent().hasClass 'disabled'

			# Clear the timetable
			$('tr.success').removeClass 'success'

			# Save the day
			availabilityList[dayListIndex].saveDay()

			# Incremement the index so that we can go the previous day
			if dayListIndex-1 >= 0
				dayListIndex--
			
			# If there are no more days before this, disable the previous button 
			if dayListIndex == 0
				$(@).parent().addClass 'disabled'	

			# Show the day
			showDay()

			# Check if the user has said they can do all day for the new day
			checkAllDay()



	$('.available-all-day').on 'click', ->

		# If the user cant do all day
		if $(@).hasClass('btn-warning')
			# Clear the timetable
			$('#time-availability tr').removeClass 'success'

			# Store this in the object
			availabilityList[dayListIndex].allDay = 0

			# Remove all the time availabilities from the object
			availabilityList[dayListIndex].resetAvailabilities()

		# If the user can do all day
		else
			# Fill the timetable
			$('#time-availability tr').addClass 'success'

			# Store this in the object
			availabilityList[dayListIndex].allDay = 1

			# Loop through each time slot and add it to the array of time availabilities in the day object
			$.each $('#time-availability tr'), (i) ->
				availabilityList[dayListIndex].addAvailability(i)

		# Switch the button styles so the action is reversible 
		switchAvailabilityButton()