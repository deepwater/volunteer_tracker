$ ->
  setTimeout =>
    $('.alert-dismissable').fadeOut().queue(->
        $(this).remove())
  , 8*1000

  $('.dataTables').dataTable()
  $('.dataTablesWithoutPagination').dataTable
    "bPaginate": false


  $('.new_department_assistant button').on 'click', ->
    $(@).addClass('disabled')

  $("#on_behalf").on 'change', ->
    $this = $(this)
    $.ajax
      url: '/users/sign_out'
      type: 'DELETE'
      success: ->
        $.ajax
          url: '/users/sign_in'
          type: 'POST'
          data: { on_behalf: $this.val() }
          success: ->
            window.location.href = "/"
