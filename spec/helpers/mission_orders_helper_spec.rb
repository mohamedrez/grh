require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MissionOrdersHelper. For example:
#
# describe MissionOrdersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MissionOrdersHelper, type: :helper do
  describe '#mission_order_status' do
    let(:user) { create(:user) }
    let(:site) { create(:site, id: 1) }
    let(:mission_order) { create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report") }

    context 'when type is "badge"' do
      it 'returns the correct status for a rejected mission order' do
        mission_order.stub(:rejected?).and_return(true)
        expect(mission_order_status(mission_order, "badge")).to eq({ color: 'red', text: t('views.shared.rejected') })
      end

      it 'returns the correct status for a mission order paid by accountant' do
        mission_order.stub(:paid_by_accountant?).and_return(true)
        expect(mission_order_status(mission_order, "badge")).to eq({ color: 'green', text: t('attributes.mission_order.aasm_states.paid_by_accountant') })
      end

      it 'returns the correct status for a mission order paid by holding treasury' do
        mission_order.stub(:paid_by_holding_treasury?).and_return(true)
        expect(mission_order_status(mission_order, "badge")).to eq({ color: 'green', text: t('attributes.mission_order.aasm_states.paid_by_holding_treasury') })
      end
    end

    context 'when type is "simple_button"' do
      it 'returns the correct status for a mission order will validate by manager' do
        expect(mission_order_status(mission_order, "simple_button")).to eq({text: t("views.mission_orders.validate_by_manager"), aasm_state: "validated_by_manager"})
      end

      it 'returns the correct status for a mission order will validate by hr' do
        mission_order.update!(aasm_state: "validated_by_manager")
        expect(mission_order_status(mission_order, "simple_button")).to eq({text: t("views.mission_orders.validate_by_hr"), aasm_state: "validated_by_hr"})
      end
    end

    context 'when type is "pay_button"' do
      it 'returns the correct status for a mission order will pay by accountant' do
        mission_order.update!(aasm_state: "validated_by_hr", mission_type: "site")
        expect(mission_order_status(mission_order, "pay_button")).to eq({text: t("views.mission_orders.pay_by_accountant")})
      end

      it 'returns the correct status for a mission order will pay by holding treasury' do
        mission_order.update!(aasm_state: "validated_by_hr", mission_type: "project")
        expect(mission_order_status(mission_order, "pay_button")).to eq({text: t("views.mission_orders.pay_by_holding_treasury")})
      end
    end
  end
end
