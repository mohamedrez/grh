require 'rails_helper'

RSpec.describe UserRequestPolicy do
  describe "relation scope" do
    let(:admin_user) { create(:user) }
    let(:hr_user) { create(:user) }
    let(:manager_user) { create(:user) }
    let(:user) { create(:user, manager_id: manager_user.id) }
    let(:other_user) { create(:user) }

    let(:target) { UserRequest.all }

    before do
      Role.create!(user_id: admin_user.id, name: :admin)
      Role.create!(user_id: hr_user.id, name: :hr)

      time_requests = [
        create(:time_request, id: 1, user_id: user.id, start_date: Date.today, end_date: (Date.today + 7)),
        create(:time_request, id: 2, user_id: user.id, start_date: Date.today, end_date: (Date.today + 7)),
        create(:time_request, id: 3, user_id: other_user.id, start_date: Date.today, end_date: (Date.today + 7))
      ]
    end    

    context "Admin will get all the UserRequests" do
      let(:policy) { described_class.new(user: admin_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(3) }
    end

    context "HR will get all the UserRequests" do
      let(:policy) { described_class.new(user: hr_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(3) }
    end

    context "Manager will gets UserRequests of his team" do
      let(:policy) { described_class.new(user: manager_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(2) }
    end
  end
end
