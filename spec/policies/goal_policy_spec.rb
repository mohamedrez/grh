require 'rails_helper'

RSpec.describe GoalPolicy do
  describe "relation scope" do
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
end
