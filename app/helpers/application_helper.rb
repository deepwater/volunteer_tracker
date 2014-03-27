module ApplicationHelper

  def error_list(errors)
    content_tag('ul') do
      html = ''
      errors.each do |error|
        html << content_tag(:li, "#{error[0]} - #{error[1].join(', ')}")
      end
      html.html_safe
    end.html_safe
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
