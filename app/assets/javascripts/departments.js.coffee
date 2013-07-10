# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.initDepartmentsShowPage = ()->
  reloadSchedule=(dateid)->
    $.ajax "#{window.location.pathname}/schedule/2013/#{dateid[0..1]}/#{dateid[2..]}",
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        $("div[id=#{dateid}]").text "Error: #{textStatus}"

      success: (data, textStatus, jqXHR) ->
        $("div[id=#{dateid}]").html data
        do $("table[id=blocks#{dateid}]").dataTable
        $('.timepicker').timepicker()
        $('.delete-department-block')
          .on 'click', ->
            setTimeout ->
              window.location.reload()
            , 200

        $('.create_department_block').on 'click', ->
          modal = $(@).attr('href')
          console.log modal
          $el = $(modal + " #department_block_name")

          setTimeout ->
            $el.focus()
          , 300

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

      reloadSchedule window.location.hash.replace('#','')

      hash = $(@).attr 'href'

      $(hash + ' #day_hash:hidden').val hash.replace('#','')



  reloadSchedule $('li.active a').attr('href').replace('#','')
