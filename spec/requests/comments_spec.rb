require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:time_request) { create(:time_request, user_id: user.id) }
  let(:user_request) { create(:user_request, user_id: user.id, requestable: time_request) }
  let(:comment) { create(:comment, commentable: user_request, author_id: user.id) }

  let(:valid_attributes) { { content: "i wanna 2 days off" } }
  let(:invalid_attributes) { { content: "" } }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns a success response" do
      get comments_path(commentable_type: "UserRequest", commentable_id: user_request.id)
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get edit_comment_path(id: comment.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context 'when the comment is successfully created' do
      before do
        post "/comments", params: {commentable_type: "UserRequest", commentable_id: user_request.id, comment: valid_attributes}
      end

      it 'creates a new commentt' do
        expect(Comment.count).to eq(1)
      end

      it 'returns a redirect status response' do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the comments" do
        expect(response).to redirect_to(comments_url(commentable_type: "UserRequest", commentable_id: user_request.id))
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context 'when the comment fails to save' do
      before do
        post "/comments", params: {commentable_type: "UserRequest", commentable_id: user_request.id, comment: invalid_attributes}
      end

      it 'does not create a new emergency contact' do
        expect(Comment.count).to eq(0)
      end

      it 'returns a redirect status response' do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the comments" do
        expect(response).to redirect_to(comments_url(commentable_type: "UserRequest", commentable_id: user_request.id))
      end

      it 'sets the flash alert' do
        expect(flash[:alert]).to eq(I18n.t("flash.specific.comment_cant_be_blank"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch "/comments/#{comment.id}", params: {comment: valid_attributes}
      end

      it "updates the requested comment" do
        comment.reload
        expect(comment.content).to eq("i wanna 2 days off")
      end

      it 'returns a redirect status response' do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the comments" do
        expect(response).to redirect_to(comments_url(commentable_type: comment.commentable_type, commentable_id: comment.commentable_id))
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end
    end

    context "with invalid parameters" do
      before do
        patch "/comments/#{comment.id}", params: {comment: invalid_attributes}
      end

      it 'returns a redirect status response' do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the comments" do
        expect(response).to redirect_to(comments_url(commentable_type: comment.commentable_type, commentable_id: comment.commentable_id))
      end

      it 'sets the flash alert' do
        expect(flash[:alert]).to eq(I18n.t("flash.specific.comment_cant_be_blank"))
      end
    end
  end
end
