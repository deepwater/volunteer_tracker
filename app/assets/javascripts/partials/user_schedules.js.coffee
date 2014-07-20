$ ->
  return unless $("#inactive-check-ins-table").length > 0

  $("#inactive-check-ins-table").on 'blur keypress', 'td.editable input', (e)->
    $this = $(this)
    return unless (e.type is 'focusout' or e.keyCode == 13) and $this.parents("form").is(":visible")
    e.preventDefault()
    e.stopPropagation()
    $td = $this.parents("td")
    time_field = $td.hasClass('time')
    check_out = $td.hasClass("check-out")
    if time_field
      time = $this.val()
      if check_out
        date = $this.parents("tr").find("td.date.check-out .input-append input").val()
      else
        date = $this.parents("tr").find("td.date.check-in .input-append input").val()
    else
      date = $this.val()
      $this.datepicker('remove')
      if check_out
        time = $this.parents("tr").find("td.check-out.time .input-append input").val()
      else
        time = $this.parents("tr").find("td.check-in.time .input-append input").val()

    $this.val "#{date} #{time}"
    $this.parents("form").submit().hide()
    $this.parents("td").find("span.value").show()

    $this.val if time_field
      time
    else
      date

    false


  $("#inactive-check-ins-table").on 'click', 'td.editable.date, td.editable.time', ->
    $this = $(this)
    $("td.editable form").addClass "hide"
    $("td.editable span.value").show()

    $this.find("span.value").hide()
    $this.find("form").removeClass "hide"

    if $this.hasClass('time')
      $this.find(".input-append").find("input").timepicker
        minuteStep: 1
    else
      $this.find(".input-append").find("input").datepicker

    # $this.find("span.add-on").click()
    # $this.find('input').focus()

$ ->
  return unless $(".check-ins-table:visible").length > 0

  loadData = ->
    data =
      q: $(".search:visible").val()
      per: $(".per_page:visible").val()
      order_charity: $(".charity:visible").data("order")
      order_department: $(".department:visible").data("order")
      order_name: $(".name:visible").data("order")
      order_check_in: $(".check_in:visible").data("order")
      order_check_out: $(".check_out:visible").data("order")


    $.ajax
      type: "GET"
      url: window.location.pathname
      data: data
      dataType: "script"


  $(".search:visible").on 'keyup', (e)->
    loadData() if e.keyCode == 13
    false

  $('.search:visible').on 'blur', ->
    loadData()
    false

  $(".per_page:visible").on 'change', ->
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
