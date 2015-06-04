$ ->
  $('#section-tab-navigation a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    e.preventDefault()
    $target = $(e.target)
    
    $target.tab('show')
    $('.tab-pane').hide()
    $(".tab-pane#{ $target.attr('href') }").show()
    if !$target.data('loaded')
      $.ajax
        url: $target.data('url')
        dataType: 'script'
        type: 'GET'
        success: ->
          $target.data('loaded', 1)

  $('#section-tab-navigation').stickyTabs()
