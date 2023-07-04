module MissionOrdersHelper
  def mission_order_status(mission_order, type)
    case type
    when "badge"
      return {color: "red", text: t("views.shared.rejected")} if mission_order.rejected?
      return {color: "green", text: t("attributes.mission_order.aasm_states.paid_by_accountant")} if mission_order.paid_by_accountant?
      return {color: "green", text: t("attributes.mission_order.aasm_states.paid_by_holding_treasury")} if mission_order.paid_by_holding_treasury?
    when "simple_button"
      return {text: t("views.mission_orders.validate_by_manager"), aasm_state: "validated_by_manager"} if mission_order.may_validate_mission_order_by_manager?
      return {text: t("views.mission_orders.validate_by_hr"), aasm_state: "validated_by_hr"} if mission_order.may_validate_mission_order_by_hr?
    when "pay_button"
      return {text: t("views.mission_orders.pay_by_accountant")} if mission_order.site? && mission_order.may_pay_mission_order_by_accountant?
      return {text: t("views.mission_orders.pay_by_holding_treasury")} if mission_order.project? && mission_order.may_pay_mission_order_by_holding_treasury?
    end
  end
end
