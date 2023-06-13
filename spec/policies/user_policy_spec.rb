require "rails_helper"

describe UserPolicy do
  let(:admin_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:regular_user) { create(:user, manager_id: manager_user.id) }
  let(:other_user) { create(:user) }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
  end

  describe "#create?" do
    subject { policy.apply(:create?) }
    let(:record) { regular_user }

    context "when the user is admin" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }
    end

    context "when the user not admin" do
      let(:policy) { described_class.new(record, user: regular_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#update?" do
    subject { policy.apply(:update?) }
    let(:record) { regular_user }

    context "when the user is admin" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }
    end

    context "when the user is onther one" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end
end
