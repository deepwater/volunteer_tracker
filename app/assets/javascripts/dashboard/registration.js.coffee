$ ->
  $('#new_user').submit (e) ->
    $checkbox = $('#age_check')
    if ($checkbox.length > 0) && !$checkbox.is(':checked')
      alert 'You must have a parent or guardian 18 years or older sign you up.'
      return false


