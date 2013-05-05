# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->	
	helpEventSetup = false
	helpEventTearDown = false

	$('.help-event-tear-down').hide()

	$('.help-event-setup button').on 'click', ->
		if $(@).hasClass 'yes' then helpEventSetup = true
		$('.help-event-setup').fadeOut()
		setTimeout ( ->
  			$('.help-event-tear-down').fadeIn()
		), 1000

	$('.help-event-tear-down button').on 'click', ->
		if $(@).hasClass 'yes' then helpEventTearDown = true
		$('.help-event-tear-down').fadeOut()

		if helpEventSetup == false then $('#setup').parent().remove()
		if helpEventTearDown == false then $('#tear-down').parent().remove()

		setTimeout ( ->
			$('.time-availability-wrapper').hide().removeClass('hidden').fadeIn()
		), 1000

	toggleLoading = () ->
		

	$('.new_user_availability')
		.bind("ajax:loading", toggleLoading)
		.bind("ajax:complete", toggleLoading)
		.bind "ajax:success", (event, data, status, xhr) ->
			$(@).siblings("table").append(data.template)

	$('.remove-user-availability').on 'click', ->
		$(@).parent().parent().remove()

	# # Holds all the day objects
	# availabilityList = []

	# # Keeps track of the current day
	# dayListIndex = 0;

	# # Day Object
	# class Day
	# 	constructor: (@id, @name) ->
	# 		@allDay = 0
	# 		@availableTimes = []		

	# 	addAvailability: (time_slot_id) ->
	# 		@availableTimes.push(time_slot_id);

	# 	removeAvailability: (time_slot_id) ->
	# 		@availableTimes.splice(@availableTimes.indexOf(time_slot_id), 1);

	# 	resetAvailabilities: ->
	# 		@availableTimes.length = 0

	# 	saveDay: ->
	# 		$.post '/dashboard/user_availabilities',
	# 			dataType: 'json' 
	# 			data: {
	# 				day_id: @id
	# 				availableTimes: @availableTimes
	# 			}
	# 			error: (jqXHR, textStatus, errorThrown) ->

	# 			success: (data, textStatus, jqXHR) ->

	# fetchDays = ->
	# 	$.get '/dashboard/days.json', (data) ->

	# 		$.each data, (i) ->	
	# 			# Creates a New Day Object

	# 			newDay = new Day(data[i].id, data[i].name)

	# 			# Adds the new day object to the list of available days
	# 			availabilityList.push(newDay)
			
	# 		# Shows the day
	# 		showDay()

	# showDay = ->
	# 	# Changes the name of the day in the pagination
	# 	$('.time-availability-wrapper .pagination .active a').html(availabilityList[dayListIndex].name)

	# 	# Checks for slots the user is already available for on new day
	# 	listOfTimes = availabilityList[dayListIndex].availableTimes

	# 	# If the user is available for time slots then display them all
	# 	if listOfTimes.length > 0

	# 		$.each listOfTimes, (i) ->
	# 			$('[data-time="' + listOfTimes[i] + '"]').parent().addClass('success').find('td').html('Available!')

	# 	$('.current-day').html(dayListIndex+1);

	# switchAvailabilityButton = ->
	# 	# Find the button element
	# 	$el = $('.available-all-day')

	# 	# Switch the button classes
	# 	$el.toggleClass 'btn-primary'
	# 	$el.toggleClass 'btn-warning'

	# 	# Add the right text and icon for the button
	# 	if $el.hasClass('btn-warning')
	# 		$el.html("<i class='icon-remove-sign icon-white'></i> I'm Not Available Today");
	# 	else
	# 		$el.html("<i class='icon-ok-sign icon-white'></i> I'm Available All Day");


	# checkAllDay = ->
	# 	# Check if the user can do the whole day so that the button can be changed
	# 	if availabilityList[dayListIndex].allDay == 0 
	# 		$('.available-all-day').addClass('btn-warning').removeClass 'btn-primary'
	# 		switchAvailabilityButton()
	# 	else
	# 		$('.available-all-day').removeClass('btn-warning').addClass 'btn-primary'
	# 		switchAvailabilityButton()

	# # Fetches all the days from the DB
	# if $('.time-availability-wrapper').length > 0
	# 	fetchDays()
	
	# # Used for mouse interactions when dragging across time slots
	# isMouseDown = false
	# isHighlighted = 0

	# # Event handlers for time slot selection
	# $('.time-availability')
	# 	.on 'mousedown', 'td', ->
	# 		isMouseDown = true

	# 		# Select the parent
	# 		$parent = $(@).parent()

	# 		$parent.toggleClass 'success'
	# 		isHighlighted = $parent.hasClass 'success'

	# 		# If the user highlighted the cell then add the index of the row to the day object as an available time
	# 		if isHighlighted 
	# 			availabilityList[dayListIndex].addAvailability($(this).attr("data-time")) 
	# 			$(@).html('Available!')
	# 		else 
	# 			availabilityList[dayListIndex].removeAvailability($(this).attr("data-time"))
	# 			$(@).html('Not Available')
			
	# 		# Stop default action: highlighting text
	# 		return false
	# 	.on 'mouseover', 'td', ->
	# 		# Check if the user is dragging
	# 		if isMouseDown
	# 			# Select the parent
	# 			$parent = $(@).parent()
	# 			$parent.toggleClass('success', isHighlighted)

	# 			isHighlighted = $parent.hasClass 'success'

	# 			# If the user highlighted the cell then add the index of the row to the day object as an available time
	# 			if isHighlighted  
	# 				availabilityList[dayListIndex].addAvailability($(this).attr("data-time")) 
	# 				$(@).html('Available!')
	# 			else 
	# 				availabilityList[dayListIndex].removeAvailability($(this).attr("data-time"))
	# 				$(@).html('Not Available')
				
	# 			# Toggle the class based on whether the user is highlighting or unhighlighting cells
	# 	.bind 'selectstart', ->
	# 		# Stop the selecting of text
	# 		return false

	# $(document)
	# 	.mouseup ->
	# 		isMouseDown = false;

	# # Click handler for next button
	# $('.next-day').on 'click', ->
	# 	# If there are no allocated time slots then show the modal
	# 	if availabilityList[dayListIndex].availableTimes.length == 0 
	# 		$('#confirmNextDay span').html($('.time-availability-wrapper li.active a').html());
	# 		$('#confirmNextDay').modal() 
	# 	else 
	# 		navigateToNextDay()

	# $('.not-available-all-day').on 'click', ->
	# 	$('.next-day').click()

	# $('#confirmNextDay .btn-danger, #confirmNextDay .close').on 'click', ->
	# 	navigateToNextDay()


	# navigateToNextDay = ->
	# 	# Save copy of the next button
	# 	$el = $('.next-day')

	# 	# If the user goes to the next day, activate previous button
	# 	$('.prev-day').parent().removeClass 'disabled'

	# 	# Make sure that there is actually a next day to go to
	# 	if !$el.parent().hasClass 'finish'

	# 		# Clear the timetable
	# 		$('tr.success td').html 'Not Available'
	# 		$('tr.success').removeClass 'success'

	# 		# Save the day
	# 		availabilityList[dayListIndex].saveDay()

	# 		# Incremement the index so that we can go to the next day
	# 		if dayListIndex+1 <= availabilityList.length
	# 			dayListIndex++

	# 		# If there are no more days after this, disable the next button
	# 		if dayListIndex == availabilityList.length-1
	# 			$el.parent().addClass 'finish'
	# 			$el.html("Finish");	

	# 		# Show the day
	# 		showDay()

	# 		# Check if the user has said they can do all day for the new day
	# 		checkAllDay()
	# 	else
	# 		check = confirm 'Are you sure you are finished adding your time availability?'
	# 		if check then window.location.href = "/dashboard/user_charities"

	# $('.prev-day').on 'click', ->
	# 	# If the user goes to the previous day, activate next button
	# 	$('.next-day').parent().removeClass 'disabled'

	# 	# Make sure that there is actually a previous day to go to
	# 	if !$(@).parent().hasClass 'disabled'

	# 		# Clear the timetable
	# 		$('tr.success').removeClass 'success'

	# 		# Save the day
	# 		availabilityList[dayListIndex].saveDay()

	# 		# Incremement the index so that we can go the previous day
	# 		if dayListIndex-1 >= 0
	# 			dayListIndex--
			
	# 		# If there are no more days before this, disable the previous button 
	# 		if dayListIndex == 0
	# 			$(@).parent().addClass 'disabled'	

	# 		# Show the day
	# 		showDay()

	# 		# Check if the user has said they can do all day for the new day
	# 		checkAllDay()

	# $('.available-all-day').on 'click', ->
	# 	# If the user cant do all day
	# 	if $(@).hasClass('btn-warning')
	# 		# Clear the timetable
	# 		$('.time-availability tr').removeClass('success').find('td').html('Not Available')

	# 		# Store this in the object
	# 		availabilityList[dayListIndex].allDay = 0

	# 		# Remove all the time availabilities from the object
	# 		availabilityList[dayListIndex].resetAvailabilities()

	# 	# If the user can do all day
	# 	else
	# 		availabilityList[dayListIndex].resetAvailabilities()

	# 		# Fill the timetable
	# 		$('.time-availability tr').addClass('success').find('td').html('Available!')

	# 		# Store this in the object
	# 		availabilityList[dayListIndex].allDay = 1

	# 		# Loop through each time slot and add it to the array of time availabilities in the day object
	# 		$.each $('.time-availability tr td'), (i) ->
	# 			availabilityList[dayListIndex].addAvailability($(this).attr("data-time"))

	# 	# Switch the button styles so the action is reversible 
	# 	switchAvailabilityButton()