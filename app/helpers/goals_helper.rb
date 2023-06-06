module GoalsHelper
  def button_class_for_goal_status(goal)
    case goal.status
    when "not_achieved"
      "bg-red-50 text-red-700 ring-red-600/10"
    when "partially_achieved"
      "bg-green-50 text-green-700 ring-green-600/10"
    when "completed"
      "bg-green-50 text-green-700 ring-green-600/10"
    when "overpassed"
      "bg-indigo-50 text-indigo-700 ring-indigo-600/10"
    else
      "bg-gray-50 text-gray-700 ring-gray-600/10"
    end
  end
end
