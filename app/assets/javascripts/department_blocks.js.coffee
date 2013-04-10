# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('.timepicker').timepicker({
	})

	$('.timepicker-first').on 'changeTime.timepicker', (e) ->

		$second = $('.timepicker-second')

		hours = e.time.hours
		minutes = e.time.minutes
		meridian = e.time.meridian

		if hours < 10 then hours = "0" + hours

		$second.timepicker('setTime', hours + ":" + minutes + " " + meridian)
