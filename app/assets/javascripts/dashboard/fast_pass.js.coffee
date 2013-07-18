$ ->
  return unless $("#fast-pass-table").length > 0
  $("#check_in_user_schedule_id").focus()

  $("#new_check_in").on 'ajax:success', (e, result)->
    $("#check_in_user_schedule_id").val("")
    if result.errors
      alert result.errors.join(', ')
    else
      if result.user_data
        $tr = $('<tr/>')
        $tr.append $("<td/>", text: result.user_data.name)
        $tr.append $("<td/>", text: result.user_data.user_schedule_id)

        $("#fast-pass-table tbody").prepend $tr
        