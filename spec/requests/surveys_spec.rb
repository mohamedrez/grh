require 'rails_helper'

RSpec.describe "Surveys", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/surveys/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/surveys/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/surveys/create"
      expect(response).to have_http_status(:success)
    end
  end

end
