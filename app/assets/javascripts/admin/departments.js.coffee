$ ->
	toggleLoading = () ->
		console.log 'test'


	$('.unassign-department-manager')
		.on 'click', ->
			setTimeout ->
				window.location.reload()
			, 200			
			
			
