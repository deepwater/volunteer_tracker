module ApplicationHelper

  def error_list(response)
    content_tag('ul') do
      html = ''
      response[:errors].each do |error|
        html << content_tag(:li, "#{error[0]} - #{error[1].join(', ')}")
      end
      html << content_tag(:li, link_to('CSV with errors', response[:link]))
      html.html_safe
    end
  end

  def in_twelve_hour_time(time)
    t = Time.parse(time)
    return t.strftime("%I:%M %p")
  end
  
  def nav_link(link)
    recognized = Rails.application.routes.recognize_path(link)
    (recognized[:controller] == params[:controller] && recognized[:action] == params[:action]) ? "active" : ""
  end

  def flash_class(type)
    case type
    when :alert
      "alert alert-error"
    when :notice
      "alert alert-success"
    else
      ""
    end
  end
end
