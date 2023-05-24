require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user, admin: true) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get reviews_path
      expect(response).to be_successful
    end
  end
end
