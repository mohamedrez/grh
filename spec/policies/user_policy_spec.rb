require "rails_helper"

describe UserPolicy do
  let(:admin_user) { create(:user, admin: true) }
  let(:manager_user) { create(:user) }
  let(:regular_user) { create(:user, manager_id: manager_user.id) }
  let(:other_user) { create(:user) }

  describe "#index?" do
    subject { policy.apply(:index?) }
    let(:records) { [admin_user, manager_user, regular_user, other_user] }

    context "when the user is admin" do
      let(:policy) { described_class.new(records, user: admin_user) }
      it { is_expected.to eq true }
    end

    context "when the user not admin" do
      let(:policy) { described_class.new(records, user: regular_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#show?" do
    subject { policy.apply(:show?) }
    let(:record) { regular_user }

    context "when the user is admin" do
      let(:policy) { described_class.new(record, user: admin_user) }
      it { is_expected.to eq true }
    end

    context "when the user is the manager" do
      let(:policy) { described_class.new(record, user: manager_user) }
      it { is_expected.to eq true }
    end

    context "when the user is the same as the record" do
      let(:policy) { described_class.new(record, user: regular_user) }
      it { is_expected.to eq true }
    end

    context "when the user is onther one" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
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

    context "when the user is the same as the record" do
      let(:policy) { described_class.new(record, user: regular_user) }
      it { is_expected.to eq true }
    end

    context "when the user is onther one" do
      let(:policy) { described_class.new(record, user: other_user) }
      it { is_expected.to eq false }
    end
  end
end
