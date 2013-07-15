$ ->
  return unless $("#scheduled-check-ins-table, #active-check-ins-table, #inactive-check-ins-table").length > 0

  loadData = ->
    data =
      q: $("#search").val()
      per: $("#per_page").val()
      order_charity: $("#charity").data("order")
      order_department: $("#department").data("order")
      order_name: $("#name").data("order")
      order_check_in: $("#check_in").data("order")
      order_check_out: $("#check_out").data("order")


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

  $("th.sorting").on 'click', ->
    $this = $(this)
    $("th.sorting").not($this).removeClass("sorting_asc").removeClass("sorting_desc").data("order", "")
    if $this.hasClass("sorting_asc")
      $this.data "order", "desc"
      $this.addClass("sorting_desc").removeClass("sorting_asc")
    else
      $this.data "order", "asc"
      $this.addClass("sorting_asc").removeClass("sorting_desc")

    loadData()
    false
