$ ->
	$('#new_user').submit (e) ->

		if !$('#age_check').is(':checked')
			alert 'You must have a parent or guardian 18 years or older sign you up.'
			return false


