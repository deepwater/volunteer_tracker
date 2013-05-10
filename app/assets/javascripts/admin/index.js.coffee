$(document).ready ->
  $("#section-tab-navigation li a").on "click", (e) ->
    e.preventDefault()
    target = e.target
    
    $(target).tab('show')
    $('.section-tab').hide()
    $(".section-tab#{ $(target).attr('href') }").show()