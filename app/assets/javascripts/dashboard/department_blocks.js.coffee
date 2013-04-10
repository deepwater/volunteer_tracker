$ ->
	toggleLoading = () ->
		console.log 'test'

	$('.new_user_schedule')
		.bind("ajax:loading", toggleLoading)
		.bind("ajax:complete", toggleLoading)
		.bind "ajax:success", (event, data, status, xhr) ->
			window.location.reload()


	$('.unschedule-user')
		.on 'click', ->
			setTimeout ->
				window.location.reload()
			, 200


	$('.unassign-volunteer-manager')
		.on 'click', ->
			setTimeout ->
				window.location.reload()
			, 200			
			
			
