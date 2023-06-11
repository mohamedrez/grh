require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:users) { [create(:user, admin: true), create(:user)] }

  let(:review) { create(:review, review_type: "manager_review") }

  let(:valid_attributes) do
    {
      name: "Month review",
      start_date: "2023-06-09",
      end_date: "2023-06-16",
      review_type: "manager_review",
      user_ids: [users.first.id, users.last.id],
      sections_attributes: [
        {
          name: "Section 1",
          description: "Section 1 Description",
          section_type: "strengths_opportunities",
          questions_attributes: [
            {
              name: "Question 1",
              question_type: "single_select",
              options_attributes: [
                { name: "Option 1" },
                { name: "Option 2" }
              ]
            },
            {
              name: "Question 2",
              question_type: "multiple_select",
              options_attributes: [
                { name: "Option 3" },
                { name: "Option 4" }
              ]
            }
          ]
        },
        {
          name: "Section 2",
          description: "Section 2 Description",
          section_type: "goals",
          questions_attributes: [
            {
              name: "Question 3",
              question_type: "textbox"
            }
          ]
        }
      ]
    }
  end

  let(:invalid_attributes) do
    {
      name: nil,
      start_date: nil,
      end_date: nil,
      review_type: nil,
      user_ids: nil,
      sections_attributes: nil
    }
  end

  before do
    sign_in users.first
  end

  describe "GET /index" do
    it "renders a successful response" do
      get reviews_path
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get review_path(id: review.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_review_path
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_review_path(id: review.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      before do
        post reviews_path, params: {review: valid_attributes}
      end

      it 'creates a new Review' do
        expect(Review.count).to eq(1)
      end

      it "renders a response with 302" do
        expect(response).to have_http_status(302)
      end

      it "redirects to the created Review" do
        expect(response).to redirect_to(review_path(Review.last))
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      before do
        post reviews_path, params: {review: invalid_attributes}
      end

      it 'creates a new Review' do
        expect(Review.count).to eq(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch review_path(id: review.id), params: {review: valid_attributes}
      end

      it "updates the requested Review" do
        review.reload
        expect(review.name).to eq("Month review")
        expect(review.start_date).to eq(Date.new(2023, 6, 9))
        expect(review.end_date).to eq(Date.new(2023, 6, 16))
        expect(review.review_type).to eq("manager_review")

        expect(review.sections.count).to eq(2)
        expect(review.sections.first.name).to eq("Section 1")
        expect(review.sections.last.name).to eq("Section 2")

        expect(review.sections.first.questions.count).to eq(2)
        expect(review.sections.first.questions.first.name).to eq("Question 1")
        expect(review.sections.first.questions.last.name).to eq("Question 2")

        expect(review.sections.first.questions.first.options.count).to eq(2)
        expect(review.sections.first.questions.first.options.first.name).to eq("Option 1")
        expect(review.sections.first.questions.first.options.last.name).to eq("Option 2")
      end

      it "renders a response with 302" do
        expect(response).to have_http_status(302)
      end

      it "redirects to the Review" do
        expect(response).to redirect_to(review_url(review))
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch review_path(id: review.id), params: {review: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete review_path(id: review.id)
    end

    it "destroys the expense" do
      expect(Review.count).to eq(0)
    end

    it "renders the Turbo Stream response" do
      expect(response).to have_http_status(:success)
      expect(response.body).to include("turbo-stream")
      expect(response.body).to include("remove")
      expect(response.body).to include("replace")
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_destroyed"))
    end
  end
end
