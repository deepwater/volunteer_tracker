# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('.timepicker').timepicker();

	$('.timepicker').on 'blur', (e) ->

		val = $(@).val()

		split = val.split " "
		time = split[0]
		meridian = split[1]

		time_split = time.split ":"
		hours = parseInt time_split[0]
		minutes = parseInt time_split[1]

		if minutes != "15" && minutes != "30" && minutes != "45" && minutes != "00"
			minutes = (parseInt((minutes + 7.5)/15) * 15) % 60
			$(@).timepicker('setTime', hours + ":" + minutes + " " + meridian)