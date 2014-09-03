$ ->
  $('#volunteers_list_table').dataTable
    processing: true
    serverSide: true
    # paging: false
    pagingType: 'full_numbers'
    lengthMenu: [ 99999 ]
    ajax: $('#volunteers_list_table').data('source')
    dom: 'T<"clear">lfrtip'
    columnDefs: [
      targets: [ -1, -2 ]
      sortable: false
    ]
    tableTools:
      aButtons: false

  # FIXME: move this hack to css
  $('#volunteers_list_table_length').hide()
  $('#volunteers_list_table_paginate').hide()