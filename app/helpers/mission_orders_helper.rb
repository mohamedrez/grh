module MissionOrdersHelper
  def button_classes(state)
    case state
    when :reject
      "bg-red-500 hover:bg-red-400"
    when :pay_by_accountant, :pay_by_holding_treasury
      "bg-green-500 hover:bg-green-400"
    when :validate_by_manager, :validate_by_hr
      "bg-indigo-500 hover:bg-indigo-400"
    end
  end
end
