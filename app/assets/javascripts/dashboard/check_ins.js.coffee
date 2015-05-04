# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.bootstrap-timepicker').datetimepicker
  	format: "hh:mm a"

  $("#section-navigation li a").on "click", (e) ->
    e.preventDefault()
    $target = $(e.target)

    $target.tab('show')
    $('.section-tab').hide()
    $(".section-tab#{ $target.attr('href') }").show()
    if !$target.data("loaded")
      $.ajax
        url: $target.data('url')
        dataType: 'script'
        type: 'GET'
        success: ->
          $target.data("loaded", 1)