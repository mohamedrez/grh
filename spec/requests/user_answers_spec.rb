require 'rails_helper'

RSpec.describe "UserAnswers", type: :request do
  let(:review) { create(:review, review_type: "manager_review") }

  let(:author) { create(:user) }
  let(:user) { create(:user, manager_id: author.id) }

  let(:user_answer) { create(:user_answer, review_id: review.id, author_id: author.id, user_id: user.id) }

  before do
    sign_in author
  end

  describe "GET /show" do
    it "renders a successful response" do
      get review_user_answer_path(review_id: review.id, id: user_answer.id, user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_review_user_answer_path(review_id: review.id, user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    before do
      section = create(:section, name: "Section 1", description: "Section 1 Description", section_type: "strengths_opportunities", review_id: review.id)
      create(:question, id: 1, name: "Question 1", question_type: "textbox", section_id: section.id)

      post review_user_answers_path(review_id: review.id), params: {text_questions: {"1"=>"Answer of question 1"}, user_id: user.id}
    end

    it 'creates a new UserAnswer' do
      expect(UserAnswer.count).to eq(1)
    end

    it "renders a response with 302" do
      expect(response).to have_http_status(302)
    end

    it "redirects to the UserAnswer" do
      expect(response).to redirect_to(review_user_answer_path(review, UserAnswer.last, user_id: user.id))
    end

    it "sets a success flash message" do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
    end
  end
end
