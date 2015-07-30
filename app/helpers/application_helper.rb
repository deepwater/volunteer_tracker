module ApplicationHelper

  def in_twelve_hour_time(time)
    t = Time.parse(time)
    return t.strftime("%l:%M %p")
  end

  def pretty_role(role)
    role.titleize.split("_").join.camelize
  end

  def nav_link(link)
    recognized = Rails.application.routes.recognize_path(link)
    (recognized[:controller] == params[:controller] && recognized[:action] == params[:action]) ? "active" : ""
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-error", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end
end
