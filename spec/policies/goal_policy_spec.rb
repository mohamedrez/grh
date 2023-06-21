require 'rails_helper'

RSpec.describe GoalPolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user1) { create(:user) }
  let(:manager_user2) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user1.id) }
  let(:other_user) { create(:user, manager_id: manager_user2.id) }

  let(:target) { Goal.all }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
    Role.create!(user_id: manager_user1.id, name: :manager)
  end

  describe "relation scope" do
    before do
      goals = [
        create(:goal, id: 1, owner_id: user.id, author_id: manager_user1.id),
        create(:goal, id: 2, owner_id: user.id, author_id: manager_user1.id),
        create(:goal, id: 3, owner_id: other_user.id, author_id: manager_user2.id)
      ]
    end

    context "Admin will get all the Goals" do
      let(:policy) { described_class.new(user: admin_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(3) }
    end

    context "HR will get all the Goals" do
      let(:policy) { described_class.new(user: hr_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(3) }
    end

    context "Manager will gets Goals of his team" do
      let(:policy) { described_class.new(user: manager_user1, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(2) }
    end
  end

  describe "#has_role_manager?" do
    subject { policy.apply(:has_role_manager?) }
  
    context "returns true if the current_user has manager role" do
      let(:policy) { described_class.new(user: manager_user1) }
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

  describe "#show?" do
    subject { policy.apply(:show?) }
    let(:record) { create(:goal, id: 1, owner_id: user.id, author_id: manager_user1.id) }

    context "Admin and HR can see the full profile" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }

      context "when user is the same as the record, can see the full profile" do
        let(:policy) { described_class.new(record, user: user) }
        it { is_expected.to eq true }
      end
  
      context "when user is the manager of the record, can see the full profile" do
        let(:policy) { described_class.new(record, user: manager_user1) }
        it { is_expected.to eq true }
      end
  
      context "when user is neither HR, admin, nor related to the record, can't see the full profile" do
        let(:policy) { described_class.new(record, user: other_user) }
        it { is_expected.to eq false }
      end
    end
  end
end
