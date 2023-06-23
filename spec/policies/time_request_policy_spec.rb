require 'rails_helper'

RSpec.describe TimeRequestPolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:other_user) { create(:user) }

  let(:record) { create(:time_request, id: 1, user_id: user.id) }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
    Role.create!(user_id: manager_user.id, name: :manager)
  end

  describe "#show?" do
    subject { policy.apply(:show?) }

    context "Admin and HR can see the time_request" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user is the same as the record, can see the time_request" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq true }
    end

    context "when user is the manager of the record, can see the time_request" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user is neither HR, admin, nor related to the record, can't see the time_request" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#approve?" do
    subject { policy.apply(:approve?) }

    context "Admin and HR can approve the time_request" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }
  
      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user is the manager of the record, can approve the time_request" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user is neither HR, admin, nor the manager of the time_request user, can't see the time_request" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end
end
