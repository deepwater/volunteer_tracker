$ ->
	$("#check_in_user_schedule_id").focus()

	$("#check_in_user_schedule_id").on 'input', ->
		$('.table').prepend("<tr><td>" + $(@).val() + "</td></tr>")
		$(@).parent().submit()

		$(@).val("")