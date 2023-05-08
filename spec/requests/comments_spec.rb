require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:time_request) { create(:time_request, user_id: user.id) }
  let(:user_request) { create(:user_request, user_id: user.id, requestable: time_request) }
  let(:comment) { create(:comment, user_request_id: user_request.id, author_id: user.id) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns a success response" do
      get comments_path(user_request_id: user_request.id)
      expect(response).to be_successful
    end

    it "contains comments for that request" do
      comment1 = create(:comment, user_request_id: user_request.id, author_id: user.id)
      comment2 = create(:comment, user_request_id: user_request.id, author_id: user.id)
      get comments_path(user_request_id: user_request.id)
      expect(response.body).to include(comment1.content)
      expect(response.body).to include(comment2.content)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get edit_comment_path(id: comment.id, user_request_id: user_request.id)
      expect(response).to be_successful
    end
  end
end
