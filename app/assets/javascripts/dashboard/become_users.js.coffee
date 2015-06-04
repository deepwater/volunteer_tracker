$ ->
  $('#become_list_table').dataTable
    processing: true
    serverSide: true
    pagingType: 'full_numbers'
    lengthMenu: [[10, 25, 50, 99999], [10, 25, 50, "All"]]
    ajax: $('#become_list_table').data('source')
    dom: 'T<"clear">lfrtip'
    columnDefs: [
      targets: [ -1, -2 ]
      sortable: false
    ]
    tableTools:
      aButtons: false
