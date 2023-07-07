require 'rails_helper'

RSpec.describe ExpensePolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:manager_user2) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:accountant_user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:record) { create(:expense, id: 1, user_id: user.id) }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
    Role.create!(user_id: manager_user.id, name: :manager)
    Role.create!(user_id: manager_user2.id, name: :manager)
    Role.create!(user_id: accountant_user.id, name: :accountant)
  end

  describe "#show?" do
    subject { policy.apply(:show?) }

    context "Admin and HR can see the expense" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user is the same as the record, can see the expense" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq true }
    end

    context "when user is the manager of the record, can see the expense" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user is neither HR, admin, nor related to the record, can't see the expense" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#validate_by_manager?" do
    subject { policy.apply(:validate_by_manager?) }

    context "when user has manger role and the manager of the record, can validate the expense" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user has manger role and the not manager of the record, can't validate the expense" do
      let(:policy) { described_class.new(record, user: manager_user2) }
      it { is_expected.to eq false }
    end

    context "when user hasn't manger role and the manager of the record" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it "can't validate the expense" do 
        Role.where(user_id: manager_user.id, name: :manager).destroy_all
        is_expected.to eq false
      end
    end
  end

  describe "#validate_by_hr?" do
    subject { policy.apply(:validate_by_hr?) }

    context "when user has hr role, can validate the expense" do
      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user hasn't hr role, can't validate the expense" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq false }
    end
  end

  describe "#pay?" do
    subject { policy.apply(:pay?) }

    context "when user has accountant role, can pay the expense" do
      let(:policy) { described_class.new(record, user: accountant_user) }
      it { is_expected.to eq true }
    end

    context "when user hasn't hr role, can't pay the expense" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq false }
    end
  end

  describe "#back_to_modify?" do
    subject { policy.apply(:back_to_modify?) }

    context "when user has manger role and the manager of the record, can back_to_modify" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user has hr role, can back_to_modify" do
      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user has accountant role, can back_to_modify" do
      let(:policy) { described_class.new(record, user: accountant_user) }
      it { is_expected.to eq true }
    end
  end
end
