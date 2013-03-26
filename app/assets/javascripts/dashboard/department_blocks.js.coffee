$ ->
	toggleLoading = () ->
		console.log 'test'

	$('.new_user_schedule')
		.bind("ajax:loading", toggleLoading)
		.bind("ajax:complete", toggleLoading)
		.bind "ajax:success", (event, data, status, xhr) ->
			# $('.scheduled-user-table').append(data.template).find('tr').addClass('success').delay(300).queue ->
			#     $(@).removeClass("success");

			# $(@).parent().parent().fadeOut("slow")
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
			
			
