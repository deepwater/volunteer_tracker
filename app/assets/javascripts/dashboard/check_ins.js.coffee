# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

loadData = (element) ->
  loadurl = element.data('url')
  $.ajax
    url: loadurl
    type: 'get'
  element.tab 'show'
  false

$ ->
  $('.bootstrap-timepicker').datetimepicker
  	format: "hh:mm a"

  $('[data-toggle="tabajax"]').click (e) ->
    $(".section-tab").html('')
    $element = $(this)
    loadData($element)

$(window).load ->
  element = $("#volunteer-section-tabs li.active a")
  loadData(element)
  return