$ ->
  oTable = $('#volunteers_list_table').dataTable
    bProcessing: true
    bServerSide: true
    bPaginate: false
    sAjaxSource: $('#volunteers_list_table').data('source')
    sDom: 'T<"clear">lfrtip'
    aoColumnDefs: [
      bSortable: false
      aTargets: [5, 6]
    ]
    oTableTools: 
      "aButtons": false