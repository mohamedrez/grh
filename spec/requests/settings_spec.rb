require "rails_helper"

RSpec.describe "Settings", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test-image.png'), 'image/png') }

  let(:valid_attributes) { { avatar: avatar } }

  before do
    sign_in user
  end

  describe "GET #edit" do
    it "renders a successful response" do
      get "/users/#{user.id}/settings"
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    it "updates the requested settings" do
      patch "/users/#{user.id}/settings", params: {user: valid_attributes}
      user.reload
      expect(user.avatar).to be_attached
    end

    it "redirects to the user" do
      patch "/users/#{user.id}/settings", params: {user: valid_attributes}
      user.reload
      expect(response).to redirect_to(user_settings_url(user_id: user.id))
    end
  end
end
