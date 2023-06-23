require 'rails_helper'

RSpec.describe GoalPolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:other_user) { create(:user) }

  let(:target) { Goal.all }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
    Role.create!(user_id: manager_user.id, name: :manager)
  end

  describe "#show?" do
    subject { policy.apply(:show?) }
    let(:record) { create(:goal, id: 1, owner_id: user.id, author_id: manager_user.id) }

    context "Admin and HR can see the goal" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }

      context "when user is the same as the record, can see the goal" do
        let(:policy) { described_class.new(record, user: user) }
        it { is_expected.to eq true }
      end
  
      context "when user is the manager of the record, can see the goal" do
        let(:policy) { described_class.new(record, user: manager_user) }
        it { is_expected.to eq true }
      end
  
      context "when user is neither HR, admin, nor related to the record, can't see the goal" do
        let(:policy) { described_class.new(record, user: other_user) }
        it { is_expected.to eq false }
      end
    end
  end

  describe "#create?" do
    subject { policy.apply(:create?) }
  
    context "returns true if the current_user has manager role" do
      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq true }
    end

    context "returns false if the current_user has not manager role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }
    end
  end

  describe "#has_manager_role_and_manger_of_owner_goal?" do
    subject { policy.apply(:has_manager_role_and_manger_of_owner_goal?) }
    let(:record) { create(:goal, id: 1, owner_id: user.id, author_id: manager_user.id) }

    context "when the current user is the manger of the goal owner " do
      context "returns true if the current_user has manager role" do
        let(:policy) { described_class.new(record, user: manager_user) }
        it { is_expected.to eq true }
      end
  
      context "returns false if the current_user has not manager role" do
        before do
          Role.where(user_id: manager_user.id, name: :manager).update!(name: :hr)
        end

        let(:policy) { described_class.new(record, user: manager_user) }
        it { is_expected.to eq false }
      end
    end

    context "when the current user is not the manger of the goal owner " do
      let(:manager_user2) { create(:user) }
      before do
        Role.create!(user_id: manager_user2.id, name: :manager)
      end

      context "returns false if the current_user has manager role" do
        let(:policy) { described_class.new(record, user: manager_user2) }
        it { is_expected.to eq false }
      end

      context "returns false if the current_user has not manager role" do
        before do
          Role.where(user_id: manager_user2.id, name: :hr).update!(name: :hr)
        end

        let(:policy) { described_class.new(record, user: manager_user2) }
        it { is_expected.to eq false }
      end
    end
  end
end
