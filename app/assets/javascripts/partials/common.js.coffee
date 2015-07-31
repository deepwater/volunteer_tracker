window.currentDate = ->
  d = new Date
  month = d.getMonth() + 1
  day = d.getDate()
  fragments = [
    d.getFullYear()
    (if month < 10 then '0' else '') + month
    (if day < 10 then '0' else '') + day
  ]
  fragments.join '-'

$ ->
  $('.nav-tabs:not(.fake-tabs)').stickyTabs()
