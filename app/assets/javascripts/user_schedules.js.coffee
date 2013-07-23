$ ->
  return unless $("#inactive-check-ins-table").length > 0

  $("#inactive-check-ins-table").on 'blur keypress', 'td.editable input', (e)->
    $this = $(this)
    return unless (e.type is 'focusout' or e.keyCode == 13) and $this.parents("form").is(":visible")
    e.preventDefault()
    e.stopPropagation()
    $timepicker.destroy() if $timepicker = $this.parents(".input-append").data('datetimepicker')
    time_field = $this.parents("td").hasClass('time')
    if time_field
      date = $this.parents("tr").find("td.check-date .input-append input").val()
      time = $this.val()
    else
      date = $this.val()
      time = $this.parents("tr").find("td.check-in-time .input-append input").val()

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
    $("td.editable form").hide()
    $("td.editable span.value").show()

    $this.find("form").show()
    $this.find("span.value").hide()

    options =
      language: 'en'
      pick12HourFormat: true
      format: 'yyyy-MM-dd HH:mm PP'
      pickDate: true
      pickTime: true

    if $this.hasClass('time')
      options['pickDate'] = false
      options['format'] = 'HH:mm PP'
    else
      options['pickTime'] = false
      options['format'] = 'yyyy-MM-dd'

    $this.find(".input-append").datetimepicker options
      
    $this.find("span.add-on").click()
    $this.find('input').focus()

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
