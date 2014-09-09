$ ->
  $('#volunteers_list_table').dataTable
    processing: true
    serverSide: true
    pagingType: 'full_numbers'
    lengthMenu: [ 99999 ]
    drawCallback: (settings) ->
      $('span.red').parents("tr").find("td").css("background-color": "#f2dede")
      $('span.yellow').parents("tr").find("td").css("background-color": "#fcf8e3")
      $('span.green').parents("tr").find("td").css("background-color": "#dff0d8")
      $('span.neutral').parents("tr").find("td").css("background-color": "#f9f9f9")
      return
    ajax: $('#volunteers_list_table').data('source')
    dom: 'T<"clear">lfrtip'
    columnDefs: [
      targets: [ 1, 2, 3, 4, 5, 6, 7, 8 ]
      sortable: false
    ]
    tableTools:
      aButtons: false

  # FIXME: move this hack to css
  $('#volunteers_list_table_length').hide()
  $('#volunteers_list_table_paginate').hide()