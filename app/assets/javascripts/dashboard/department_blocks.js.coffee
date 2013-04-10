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
			
			
	$('#new_department_block')
		.on 'submit', (e) ->
			# $formParent = $(@).parents("#new_department_block")

			$name = $(@).find('#department_block_name')
			$volunteers = $(@).find('#department_block_suggested_number_of_workers')

			if $name.val().length == 0
			 alert "Please Enter a Department Block Name"
			 return false

			if $volunteers.val().length == 0
			 alert "Please Enter a Number of Volunteers"
			 return false	