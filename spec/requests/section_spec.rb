require 'rails_helper'

RSpec.describe "Sections", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/section/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/section/create"
      expect(response).to have_http_status(:success)
    end
  end

end
