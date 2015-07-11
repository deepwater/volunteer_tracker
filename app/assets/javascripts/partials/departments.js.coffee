$ ->
  return unless $("#promote-users").length > 0

  loadData = (id) ->
    $block = $("##{id}")
    data =
      q: $block.find(".search-field").val()
      per: $block.find(".per-page-field").val()
      order_name: $block.find(".name").data("order")
      order_role: $block.find(".role").data("order")


    $.ajax
      type: "GET"
      url: $block.data('url')
      data: data
      dataType: "script"
    

  $(".search-field").on 'keyup', (e)->
    loadData $(this).data('table') if e.keyCode == 13
    false

  $(".per-page-field").on 'change', ->
    loadData $(this).data('table')
    false

  $("th.sorting").on 'click', ->
    $this = $(this)
    $table = $this.parents("table")
    $table.find("th.sorting").not($this).removeClass("sorting_asc").removeClass("sorting_desc").data("order", "")
    if $this.hasClass("sorting_asc")
      $this.data "order", "desc"
      $this.addClass("sorting_desc").removeClass("sorting_asc")
    else
      $this.data "order", "asc"
      $this.addClass("sorting_asc").removeClass("sorting_desc")

    loadData($table.data('table'))
    false
