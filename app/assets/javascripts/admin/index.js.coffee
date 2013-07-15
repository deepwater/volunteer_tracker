$ ->
  $("#section-tab-navigation li a").on "click", (e) ->
    e.preventDefault()
    $target = $(e.target)
    
    $target.tab('show')
    $('.section-tab').hide()
    $(".section-tab#{ $target.attr('href') }").show()
    if !$target.data("loaded")
      $.ajax
        url: $target.data('url')
        dataType: 'script'
        type: 'GET'
        success: ->
          $target.data("loaded", 1) 