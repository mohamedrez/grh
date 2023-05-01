require "rails_helper"

RSpec.describe TimeOffRequestPolicy, type: :policy do
  let(:admin) { create(:user, admin: true) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:records) { [create(:time_off_request, user_id: user.id)] }
  let(:record) { create(:time_off_request, user_id: user.id) }

  subject { described_class }

  permissions :index? do
    it "grants access to admins" do
      expect(subject).to permit(admin, records)
    end

    it "grants access to the user who requested the time off" do
      expect(subject).to permit(records.first.user_request.user, records)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, records)
    end
  end

  permissions :show? do
    it "grants access to admins" do
      expect(subject).to permit(admin, record)
    end

    it "grants access to the user who requested the time off" do
      expect(subject).to permit(record.user_request.user, record)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, record)
    end
  end

  permissions :update? do
    it "grants access to the user who requested the time off if the request is pending" do
      record.user_request.update(state: "pending")
      expect(subject).to permit(record.user_request.user, record)
    end

    it "denies access to the user who requested the time off if the request is not pending" do
      record.user_request.update(state: "approved")
      expect(subject).not_to permit(record.user_request.user, record)
    end

    it "denies access to other users" do
      expect(subject).not_to permit(other_user, record)
    end
  end
end
