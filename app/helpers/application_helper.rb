module ApplicationHelper

	def in_twelve_hour_time(time)
		t = Time.parse(time)
		return t.strftime("%I:%M %p")
	end
	
	# def nav_link(text, link, icon_class)
	def nav_link(link)
	    recognized = Rails.application.routes.recognize_path(link)
	    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
	        return "active"
	        # content_tag(:li, :class => "active") do
	        # 	content_tag(:a, text, href: link) do 
	        # 		content_tag(:i, "",class: "icon_class")
	        # 	end
	        # end
	    else
	    	return ""
	        # content_tag(:li) do
	        #     link_to( text, link)
	        # end
	    end
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
