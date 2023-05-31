# frozen_string_literal: true

module ApplicationHelper
  def inline_error_for(field, form_obj)
    html = []
    if form_obj.errors[field].any?
      html << form_obj.errors[field].map do |msg|
        tag.div(msg, class: "text-red-400 text-xs m-0 p-0 text-right mb-2")
      end
    end
    html.join
  end

  def button_class_for_goal_status(goal)
    case goal.status
    when "incomplete"
      "bg-red-50 text-red-700 ring-red-600/10"
    when "completed"
      "bg-green-50 text-green-700 ring-green-600/10"
    when "overpass"
      "bg-indigo-50 text-indigo-700 ring-indigo-600/10"
    else
      "bg-gray-50 text-gray-700 ring-gray-600/10"
    end
  end
end
