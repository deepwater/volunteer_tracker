$ ->
  $('.time-availability-wrapper').on 'click', '.remove-user-availability',->
    $(@).parent().parent().remove()

  $('.new_user_availability').submit ->
    first_time = $(@).find('.timepicker-first').val()
    second_time = $(@).find('.timepicker-second').val()

    difference = Date.parse("01/01/2014 " +second_time) - Date.parse("01/01/2014 " +first_time)

    if difference == 0 or difference < 0
      alert "Please enter an End time that is after the Start time"
      return false 

    $matchingTable = $(@).siblings('table')
    arrayOfTimes = []
    numOverlaps = 0

    $matchingTable.find('tbody tr').each (index, element) =>
      $tableColumns = $(element).children('td')

      startTime = Date.parse("01/01/2014 " +$($tableColumns[0]).text())
      endTime = Date.parse("01/01/2014 " +$($tableColumns[1]).text())

      arrayOfTimes.push {start_time:startTime, end_time: endTime}

      new_start_time = Date.parse("01/01/2014 " +first_time)
      new_end_time = Date.parse("01/01/2014 " +second_time)


      $.each arrayOfTimes, (index, element) ->
        numOverlaps++ if (new_start_time <= element.start_time && new_start_time >= element.end_time || new_start_time < element.end_time && element.end_time >= new_end_time)

      if numOverlaps > 0 
        alert "The time you entered overlaps another time that you are available for"
        return false
