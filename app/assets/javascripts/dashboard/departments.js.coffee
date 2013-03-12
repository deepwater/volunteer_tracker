$ ->
	$('#department_block_department_chooser').change ->
		newVal = $(@).val()
		window.location = "/dashboard/departments/" + newVal