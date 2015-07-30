module ApplicationHelper

  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    error: 'alert-error',
    alert: 'alert-warning',
    notice: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type, flash_type.to_s)
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert-dismissable text-center alert #{bootstrap_class_for(msg_type.to_sym)} fade in") do
        concat content_tag(:button, 'x'.html_safe, class: 'close', data: {dismiss: 'alert'})
        concat message
      end)
      flash.clear
    end
    nil
  end

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
end
