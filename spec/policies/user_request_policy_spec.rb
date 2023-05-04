require "rails_helper"

RSpec.describe UserRequestPolicy, type: :policy do
  let(:admin_user) { create(:user, admin: true) }
  let(:user) { create(:user, manager_id: admin_user.id) }
  let(:other_user) { create(:user) }
  let(:user_requests) { [create(:user_request, user_id: user.id, requestable: create(:time_request, user_id: user.id))] }
  subject { described_class }

  permissions :index? do
    it "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    it "grants access if user is the requester" do
      expect(subject).to permit(user, user_requests)
    end

    it "denies access if a user tying to access not his requests" do
      expect(subject).not_to permit(other_user, user_requests)
    end
  end

  permissions :update? do
    it "grants access if user is an admin" do
      expect(subject).to permit(admin_user)
    end

    it "denies access if user is not an admin" do
      expect(subject).not_to permit(user)
    end
  end
end
