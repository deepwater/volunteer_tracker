$ ->
  oTable = $('#users_list_table').dataTable
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#users_list_table').data('source')
    sDom: 'T<"clear">lfrtip'
    aLengthMenu: [[10, 25, 50, 99999], [10, 25, 50, "All"]]
    aoColumnDefs: [
      bSortable: false
      aTargets: [5, 6]
    ]
    oTableTools:
      aButtons : [ "copy", "csv", "xls", "pdf" ]
      sSwfPath: "//cdn.datatables.net/tabletools/2.2.4/swf/copy_csv_xls_pdf.swf"

  window.adminUserTable = oTable
