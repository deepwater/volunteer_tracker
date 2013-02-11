# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->	
	# Holds all the day objects
	availabilityList = []

	# Keeps track of the current day
	dayListIndex = 0;

	# Holds a list of all the dates 
	dayList = [
		"Sunday, July 21st, 2013", 
		"Monday, July 22nd, 2013", 
		"Tuesday, July 23rd, 2013", 
		"Wednesday, July 24th, 2013", 
		"Thursday, July 25th, 2013", 
		"Friday, July 26th, 2013", 
		"Saturday, July 27th, 2013", 
		"Sunday, July 28th, 2013", 
		"Monday, July 29th, 2013",
		"Tuesday, July 30th, 2013",
		"Wednesday, July 31st, 2013",
		"Thursday, August 1st, 2013",
	]

	# Day Object
	class Day
		constructor: (@dayName) ->
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



	
	createDay = ->

		# Creates a New Day Object
		newDay = new Day(dayList[dayListIndex])

		# Adds the new day object to the list of available days
		availabilityList.push(newDay)

		# Shows the day
		showDay()

	showDay = ->
		# Changes the name of the day in the pagination
		$('.time-availability-wrapper .pagination .active a').html(availabilityList[dayListIndex].dayName)
		
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

	# Create the first day
	createDay()

	# Used for mouse interactions when dragging across time slots
	isMouseDown = false
	isHighlighted = 0

	# Event handlers for time slot selection
	$('#time-availability td')
		.mousedown ->
			isMouseDown = true

			# Select the parent
			$parent = $(@).parent()

			$parent.toggleClass 'success'
			isHighlighted = $parent.hasClass 'success'

			# If the user highlighted the cell then add the index of the row to the day object as an available time
			if isHighlighted then availabilityList[dayListIndex].addAvailability($parent.index()) else availabilityList[dayListIndex].removeAvailability($parent.index())
			
			# Stop default action: highlighting text
			return false
		.mouseover ->
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

	$('.next-day').on 'click', ->
		# If the user goes to the next day, activate previous button
		$('.prev-day').parent().removeClass 'disabled'

		# Make sure that there is actually a next day to go to
		if !$(@).parent().hasClass 'disabled'

			# Clear the timetable
			$('tr.success').removeClass 'success'

			# Save the day
			availabilityList[dayListIndex].saveDay()

			# Incremement the index so that we can go to the next day
			if dayListIndex+1 <= dayList.length
				dayListIndex++

				# Create the day if it hasn't already been created
				if !availabilityList[dayListIndex]
					createDay()

			# If there are no more days after this, disable the next button
			if dayListIndex == dayList.length-1
				$(@).parent().addClass 'disabled'	

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