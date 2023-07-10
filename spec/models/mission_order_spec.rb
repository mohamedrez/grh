require 'rails_helper'

RSpec.describe MissionOrder, type: :model do
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
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

  describe '#available_next_state' do
    let(:mission_order) { create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08",indemnity_type: "expense_report") }

    it 'returns the correct next state for aasm_state with value created' do
      Role.create!(user_id: manager_user.id, name: :manager)

      next_state = mission_order.available_next_state(manager_user)
      expect(next_state).to eq(:validate_by_manager)
    end

    it 'returns the correct next state for aasm_state with value validated_by_manager' do
      hr_user = create(:user)
      Role.create!(user_id: hr_user.id, name: :hr)
      mission_order.update!(aasm_state: "validated_by_manager")

      next_state = mission_order.available_next_state(hr_user)
      expect(next_state).to eq(:validate_by_hr)
    end

    context "returns the correct next state for aasm_state with value validated_by_hr" do
      it 'when the mission of type site' do
        accountant_user = create(:user)
        Role.create!(user_id: accountant_user.id, name: :accountant)
        mission_order.update!(aasm_state: "validated_by_hr", mission_type: :site)

        next_state = mission_order.available_next_state(accountant_user)
        expect(next_state).to eq(:pay_by_accountant)
      end

      it 'when the mission of type project' do
        accountant_user = create(:user)
        Role.create!(user_id: accountant_user.id, name: :accountant)
        mission_order.update!(aasm_state: "validated_by_hr", mission_type: :project)

        next_state = mission_order.available_next_state(accountant_user)
        expect(next_state).to eq(:pay_by_holding_treasury)
      end
    end

    it 'returns an "" for unsupported states' do
      next_state = mission_order.available_next_state(user)
      expect(next_state).to be_empty
    end
  end
end
