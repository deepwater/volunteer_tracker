$ ->
  $('#users_list_table').dataTable
    processing: true
    serverSide: true
    ajax: $('#users_list_table').data('source')
    lengthMenu: [[10, 25, 50, 99999], [10, 25, 50, "All"]]
    dom: 'T<"clear">lfrtip'
    columnDefs: [
      targets: [ -1, -2 ]
      sortable: false
    ]
    pagingType: 'full_numbers'
    tableTools:
      sSwfPath: 'http://cdnjs.cloudflare.com/ajax/libs/datatables-tabletools/2.1.5/swf/copy_csv_xls_pdf.swf'
