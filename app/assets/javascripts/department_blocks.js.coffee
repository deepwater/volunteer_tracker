# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.timepicker').timepicker();

  $('.timepicker').on 'blur', (e) ->

    val = $(@).val()

    split = val.split " "
    time = split[0]
    meridian = split[1]

    time_split = time.split ":"
    hours = parseInt time_split[0]
    minutes = parseInt time_split[1]

    if minutes != "15" && minutes != "30" && minutes != "45" && minutes != "00"
      minutes = (parseInt((minutes + 7.5)/15) * 15) % 60
      $(@).timepicker('setTime', hours + ":" + minutes + " " + meridian)


  $("a.print-dymo-label").on 'click', (e)->
    printerName = determinePrinter()
    unless printerName
      alert("No DYMO printers are installed. Install DYMO printers.")
      return false

    $this = $(this)
    $.ajax
      url: $this.attr('href')
      type: 'GET'
      dataType: 'xml'
      success: (data)->
        label = dymo.label.framework.openLabelXml data
        label.print(printerName)

    return false

  determinePrinter = ->
    printers = dymo.label.framework.getPrinters()
    return false if (printers.length == 0)
    printerName = ""
    for i in [0..printers.length] 
      printer = printers[i]
      if (printer.printerType == "LabelWriterPrinter")
        printerName = printer.name
        break

    printerName