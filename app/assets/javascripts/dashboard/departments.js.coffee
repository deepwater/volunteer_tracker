$ ->
	firstHash = $('li.active a').attr('href')
	$(firstHash + '#day_hash:hidden').val firstHash.replace('#','')

	$('#department_block_department_chooser').change ->
		newVal = $(@).val()
		window.location = "/dashboard/departments/" + newVal

	if window.location.hash
 		$('a[href="' + window.location.hash + '"]').click()	

 	$('.nav.nav-tabs a').click ->
 		window.location.hash = $(@).attr 'href'
 		
 		hash = $(@).attr 'href'
 		hash = hash.replace('#','')

 		$("#modal_" + hash + ' #day_hash:hidden').val hash
