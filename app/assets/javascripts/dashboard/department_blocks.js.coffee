$ ->
	toggleLoading = () ->
		console.log 'test'

	$('.new_user_schedule')
		.bind("ajax:loading", toggleLoading)
		.bind("ajax:complete", toggleLoading)
		.bind "ajax:success", (event, data, status, xhr) ->
			$('<tr><td>' + data.full_name + '</td><td>Unschedule User</td></tr>').appendTo('.scheduled-user-table').addClass('success').delay(300).queue ->
			    $(@).removeClass("success");

			$(@).parent().parent().fadeOut("slow")