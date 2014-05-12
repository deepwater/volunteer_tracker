# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $('.flag_form_button').on 'click', ->
    $(@).hide()
    $(@).siblings('.flag_form').fadeIn()

