# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	oTable = $('#users_list_table').dataTable 
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#users_list_table').data('source')
		sDom: 'T<"clear">lfrtip'
		aLengthMenu: [[10, 25, 50, 99999], [10, 25, 50, "All"]]
    #users_list_table datatable
