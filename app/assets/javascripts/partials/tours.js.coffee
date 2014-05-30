
$(document).ready ->

  super_admin_dashboard_tour = new Tour(steps: [
    {
      element: "#on_behalf"
      placement: "bottom"
      title: "Welcome to Bootstrap Tour!"
      content: "Introduce new users to your product by walking them through it step by step."
    }
    {
      element: "#main-nav-toggle"
      placement: "bottom"
      title: "Welcome to Bootstrap Tour!"
      content: "Introduce new users to your product by walking them through it step by step."
    }
  ])

  volunteer_dashboard_tour = new Tour(steps: [
    {
      element: "#main-nav-toggle"
      placement: "top"
      title: "Welcome to Bootstrap Tour!"
      content: "Introduce new users to your product by walking them through it step by step."
    }
    {
      element: "#on_behalf"
      placement: "top"
      title: "Welcome to Bootstrap Tour!"
      content: "Introduce new users to your product by walking them through it step by step."
    }
  ])

  $.fn.triggerTour = (tour) ->
    $("#tour-trigger").click (e) ->
      try
        tourObj = eval(tour)
        tourObj.init()
        tourObj.restart()
      catch err
        console.log err
      e.preventDefault()
      return
    return

  return

