$ ->
  return unless $("#scheduled-check-ins-table, #active-check-ins-table, #inactive-check-ins-table").length > 0

  loadData = ->
    data =
      q: $("#search").val()
      per: $("#per_page").val()

    $.ajax
      type: "GET"
      url: window.location.pathname
      data: data
      dataType: "script"
    

  $("#search").on 'keyup', (e)->
    loadData() if e.keyCode == 13
    false

  $('#search').on 'blur', ->
    loadData()
    false

  $("#per_page").on 'change', ->
    loadData()
    false