$ ->
  oTable = $('#subaccounts_list_table').dataTable
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#subaccounts_list_table').data('source')
    sDom: 'T<"clear">lfrtip'
    aLengthMenu: [[10, 25, 50, 99999], [10, 25, 50, "All"]]
    aoColumnDefs: [
      bSortable: false
      aTargets: [3, 4, 5]
    ]
    oTableTools: 
      "aButtons": [ "copy", "csv", "xls" ]
      "sSwfPath": "http://datatables.net/release-datatables/extras/TableTools/media/swf/copy_csv_xls_pdf.swf"
