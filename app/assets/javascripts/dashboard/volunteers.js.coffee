$ ->
  oTable = $('#volunteers_list_table').dataTable
    bProcessing: true
    bServerSide: true
    bPaginate: false
    sAjaxSource: $('#volunteers_list_table').data('source')
    sDom: 'T<"clear">lfrtip'
    aoColumnDefs: [
      bSortable: false
      aTargets: [4, 5]
    ]
    oTableTools:
      "aButtons": false