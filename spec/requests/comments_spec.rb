require 'rails_helper'

RSpec.describe "/comments", type: :request do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Comment.create! valid_attributes
      get comments_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Comment" do
        expect {
          post comments_url, params: { comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the created comment" do
        post comments_url, params: { comment: valid_attributes }
        expect(response).to redirect_to(comment_url(Comment.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post comments_url, params: { comment: invalid_attributes }
        }.to change(Comment, :count).by(0)
      end


      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post comments_url, params: { comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
