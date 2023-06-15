require 'rails_helper'

RSpec.describe UserPolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:other_user) { create(:user) }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
  end

  describe "#create?" do
    subject { policy.apply(:create?) }

    context "Admin and HR can create new User" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't creates new User" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#update?" do
    subject { policy.apply(:update?) }

    context "Admin and HR can update Users" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't updates Users" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#view_full_profile?" do
    subject { policy.apply(:view_full_profile?) }
    let(:record) { user }

    context "Admin and HR can see the full profile" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(record, user: hr_user) }
      it { is_expected.to eq true }
    end

    context "when user is the same as the record, can see the full profile" do
      let(:policy) { described_class.new(record, user: user) }
      it { is_expected.to eq true }
    end

    context "when user is the manager of the record, can see the full profile" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when user is neither HR, admin, nor related to the record, can't see the full profile" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end
end
