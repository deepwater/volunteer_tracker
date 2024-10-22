$ ->
  toggleLoading = () ->
    # console.log 'test'

  $(document).on 'change', '.department_blocks_all', ->
    $(@).parents('.modal-body').find('input:checkbox').prop('checked', $(@).is(':checked'))

  $('.new_user_schedule .btn').on 'click', ->
    return false if $(@).hasClass 'disabled'
    $(@).addClass('disabled')

  $('.new_user_schedule')
    .bind("ajax:loading", toggleLoading)
    .bind("ajax:complete", toggleLoading)
    .bind "ajax:success", (event, data, status, xhr) ->
      $(@).parent().parent().remove()
      $('.scheduled-user-table').append(data.template)
      # window.location.reload()


  $('.scheduled-user-table')
    .on 'click', '.unschedule-user', ->
      setTimeout ->
        window.location.reload()
      , 200


  $('.unassign-volunteer-manager')
    .on 'click', ->
      setTimeout ->
        window.location.reload()
      , 200


  $('#new_department_block')
    .on 'submit', (e) ->
      # $formParent = $(@).parents("#new_department_block")

      $name = $(@).find('#department_block_name')
      $volunteers = $(@).find('#department_block_suggested_number_of_workers')

      if $name.val().length == 0
       alert "Please Enter a Department Block Name"
       return false

      if $volunteers.val().length == 0
       alert "Please Enter a Number of Volunteers"
       return false

      first_time = $('.timepicker-first').val()
      second_time = $('.timepicker-second').val()
      difference = Date.parse("01/01/2016 " +second_time) - Date.parse("01/01/2015 " +first_time)

      if difference == 0 or difference < 0
        alert "Please enter an End time that is after the Start time"
        return false

