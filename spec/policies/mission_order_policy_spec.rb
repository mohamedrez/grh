require 'rails_helper'

RSpec.describe MissionOrderPolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:manager_user2) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:accountant_user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:site) { create(:site, id: 1) }
  let(:record) { create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08",indemnity_type: "expense_report") }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
    Role.create!(user_id: manager_user.id, name: :manager)
    Role.create!(user_id: manager_user2.id, name: :manager)
    Role.create!(user_id: accountant_user.id, name: :accountant)
  end

  describe "#show?" do
    subject { policy.apply(:show?) }

    context "Admin and HR can see the mission_order" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user is the same as the record, can see the mission_order" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq true }
    end

    context "when user is the manager of the record, can see the mission_order" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user is neither HR, admin, nor related to the record, can't see the mission_order" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#validate_by_manager?" do
    subject { policy.apply(:validate_by_manager?) }

    context "when user has manger role and the manager of the record, can validate the mission_order" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user has manger role and the not manager of the record, can't validate the mission_order" do
      let(:policy) { described_class.new(record, user: manager_user2) }
      it { is_expected.to eq false }
    end

    context "when user hasn't manger role and the manager of the record" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it "can't validate the mission_order" do 
        Role.where(user_id: manager_user.id, name: :manager).destroy_all
        is_expected.to eq false
      end
    end
  end

  describe "#validate_by_hr?" do
    subject { policy.apply(:validate_by_hr?) }

    context "when user has hr role, can validate the mission_order" do
      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user hasn't hr role, can't validate the mission_order" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq false }
    end
  end

  describe "#pay?" do
    subject { policy.apply(:pay?) }

    context "when user has accountant role, can pay the mission_order" do
      let(:policy) { described_class.new(record, user: accountant_user) }
      it { is_expected.to eq true }
    end

    context "when user hasn't hr role, can't pay the mission_order" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq false }
    end
  end
end
