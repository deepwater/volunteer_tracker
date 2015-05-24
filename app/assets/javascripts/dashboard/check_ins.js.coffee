# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.bootstrap-timepicker').datetimepicker
  	format: "hh:mm a"

  $('[data-toggle="tabajax"]').click (e) ->
    $this = $(this)
    $(".section-tab").html('')
    loadurl = $this.data('url')
    $.ajax
      url: loadurl
      type: 'get'
    $this.tab 'show'
    false
