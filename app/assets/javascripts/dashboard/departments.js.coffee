$ ->
	$('#department_block_department_chooser').change ->
		newVal = $(@).val()
		window.location = "/dashboard/departments/" + newVal

	if $('#new_department_block').length > 0
		firstHash = $('li.active a').attr('href')
		$(firstHash + ' #day_hash:hidden').val firstHash.replace('#','')

		if window.location.hash
	 		$('a[href="' + window.location.hash + '"]').click()	

	 	$('.nav.nav-tabs a').click ->
	 		window.location.hash = $(@).attr 'href'
	 		
	 		hash = $(@).attr 'href'

	 		$(hash + ' #day_hash:hidden').val hash.replace('#','')
