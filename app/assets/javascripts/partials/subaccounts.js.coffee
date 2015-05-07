$ ->
  $('#subaccounts_list_table').dataTable
    processing: true
    serverSide: true
    ajax: $('#subaccounts_list_table').data('source')
    lengthMenu: [[10, 25, 50, 99999], [10, 25, 50, "All"]]
    dom: 'T<"clear">lfrtip'
    columnDefs: [
      targets: [ -1, -2 , -3]
      sortable: false
    ]
    pagingType: 'full_numbers'
    tableTools:
      aButtons : [ "copy", "csv", "xls", "pdf" ]
      sSwfPath: "//cdn.datatables.net/tabletools/2.2.4/swf/copy_csv_xls_pdf.swf"
