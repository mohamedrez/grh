require 'rails_helper'

RSpec.describe MissionOrder, type: :model do
  let(:user) { create(:user) }
  let(:site) { create(:site, id: 1) }

  describe "#validate_indemnity_type" do
    let(:mission_order) { build(:mission_order, user_id: user.id, site_id: site.id, start_date: start_date, end_date: end_date, indemnity_type: indemnity_type) }

    context "when start_date and end_date are present" do
      let(:start_date) { Date.new(2023, 6, 1) }
      let(:end_date) { Date.new(2023, 6, 1) }

      context "when duration is 1 day and indemnity_type is flat_rate" do
        let(:indemnity_type) { "flat_rate" }

        it "adds an error to indemnity_type" do
          mission_order.validate
          expect(mission_order.errors[:indemnity_type]).to include(I18n.t("attributes.mission_order.errors.must_be_expense_report"))
        end
      end

      context "when duration is more than 15 days and indemnity_type is expense_report" do
        let(:indemnity_type) { "expense_report" }
        let(:end_date) { Date.new(2023, 6, 17) }

        it "adds an error to indemnity_type" do
          mission_order.validate
          expect(mission_order.errors[:indemnity_type]).to include(I18n.t("attributes.mission_order.errors.must_be_flat_rate"))
        end
      end
    end

    context "when start_date or end_date is missing" do
      let(:start_date) { nil }
      let(:end_date) { Date.new(2023, 6, 2) }
      let(:indemnity_type) { "flat_rate" }

      it "does not add any errors" do
        mission_order.validate
        expect(mission_order.errors[:indemnity_type]).to be_empty
      end
    end
  end

  describe ".payment_types" do
    it "returns the correct payment types" do
      expected_payment_types = {
        "cash" => 0,
        "bank_transfer" => 1,
        "check" => 2,
        "binatna_recharge" => 3
      }

      payment_types = MissionOrder.payment_types

      expect(payment_types).to eq(expected_payment_types)
    end
  end

  describe '#state_label' do
    let(:mission_order) { create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report") }

    it 'returns the correct state label for each state' do
      mission_order.update!(aasm_state: "created")
      expect(mission_order.state_label).to eq(I18n.t('attributes.mission_order.aasm_states.created'))

      mission_order.update!(aasm_state: "validated_by_manager")
      expect(mission_order.state_label).to eq(I18n.t('attributes.mission_order.aasm_states.validated_by_manager'))

      mission_order.update!(aasm_state: "validated_by_hr")
      expect(mission_order.state_label).to eq(I18n.t('attributes.mission_order.aasm_states.validated_by_hr'))

      mission_order.update!(aasm_state: "paid_by_accountant")
      expect(mission_order.state_label).to eq(I18n.t('attributes.mission_order.aasm_states.paid_by_accountant'))

      mission_order.update!(aasm_state: "paid_by_holding_treasury")
      expect(mission_order.state_label).to eq(I18n.t('attributes.mission_order.aasm_states.paid_by_holding_treasury'))

      mission_order.update!(aasm_state: "rejected")
      expect(mission_order.state_label).to eq(I18n.t('attributes.mission_order.aasm_states.rejected'))
    end
  end
end
