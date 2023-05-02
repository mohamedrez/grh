require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }
  let(:admin_user) { create(:user, admin: true) }
  let(:user) { create(:user) }

  permissions :index? do
    xit "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    xit "denies access if user is not an admin" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :show? do
    xit "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    xit "grants access if user is the same as the record" do
      record = user
      expect(subject).to permit(user, record)
    end

    xit "denies access if user is not an admin or the same as the record" do
      record = admin_user
      expect(subject).not_to permit(user, record)
    end
  end

  permissions :create? do
    xit "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    xit "denies access if user is not an admin" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :new? do
    xit "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    xit "denies access if user is not an admin" do
      expect(subject).not_to permit(user)
    end
  end

  permissions :update? do
    xit "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    xit "grants access if user is the same as the record" do
      record = user
      expect(subject).to permit(user, record)
    end

    xit "denies access if user is not an admin or the same as the record" do
      record = admin_user
      expect(subject).not_to permit(user, record)
    end
  end

  permissions :edit? do
    xit "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    xit "grants access if user is the same as the record" do
      record = user
      expect(subject).to permit(user, record)
    end

    xit "denies access if user is not an admin or the same as the record" do
      record = admin_user
      expect(subject).not_to permit(user, record)
    end
  end
end
