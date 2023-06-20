require 'rails_helper'

RSpec.describe RolePolicy do
  let(:admin_user) { create(:user) }
  let(:hr_user) { create(:user) }
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }

  before do
    Role.create!(user_id: admin_user.id, name: :admin)
    Role.create!(user_id: hr_user.id, name: :hr)
  end

  describe "#show?" do
    subject { policy.apply(:index?) }

    context "Admin and HR can see all the Roles" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't see all the Roles" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#show?" do
    subject { policy.apply(:new?) }

    context "Admin and HR can see the Role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't see the Role" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#new?" do
    subject { policy.apply(:new?) }

    context "Admin and HR can add new Role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't add new Role" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#create?" do
    subject { policy.apply(:create?) }

    context "Admin and HR can create new Role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't create new Role" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#edit?" do
    subject { policy.apply(:edit?) }

    context "Admin and HR can edit a Role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't edit a Role" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#update?" do
    subject { policy.apply(:update?) }

    context "Admin and HR can update a Role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't update a Role" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end

  describe "#destroy?" do
    subject { policy.apply(:destroy?) }

    context "Admin and HR can delete the Role" do
      let(:policy) { described_class.new(user: admin_user) }
      it { is_expected.to eq true }

      let(:policy) { described_class.new(user: hr_user) }
      it { is_expected.to eq true }
    end

    context "If the user not Admin or HR, can't delete the Role" do
      let(:policy) { described_class.new(user: user) }
      it { is_expected.to eq false }

      let(:policy) { described_class.new(user: manager_user) }
      it { is_expected.to eq false }
    end
  end
end
