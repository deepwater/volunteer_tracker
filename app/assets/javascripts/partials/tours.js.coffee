$(document).ready ->
  tour = new Tour(steps: [
    {
      element: "#section-tab-navigation"
      placement: "top"
      title: "Welcome to Bootstrap Tour!"
      content: "Introduce new users to your product by walking them through it step by step."
    }
    {
      element: "#section-tabs"
      placement: "top"
      title: "Welcome to Bootstrap Tour!"
      content: "Introduce new users to your product by walking them through it step by step."
    }
  ]).init()
  # tour.restart()
  return