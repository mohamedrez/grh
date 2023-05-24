require 'rails_helper'

RSpec.describe "/expenses", type: :request do
  let(:user) { create(:user, id: 1, admin: true) }
  let(:expense) { create(:expense, user_id: user.id) }

  let(:valid_attributes) do
    {
      date: Date.new(2023, 05, 22),
      category: :travel,
      description: "My description is too long.",
      amount: 145.45
    }
  end

  let(:invalid_attributes) do
    {
      date: nil,
      category: nil,
      description: "My description is too long.",
      amount: nil
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_expenses_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_expense_path(user_id: user.id, id: expense.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_expense_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_expense_path(user_id: user.id, id: expense.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new expense" do
        expect {
          post "/users/#{user.id}/expenses", params: {expense: valid_attributes}
        }.to change(Expense, :count).by(1)
      end

      before do
        post "/users/#{user.id}/expenses", params: {expense: valid_attributes}
      end

      it "successfully creates expense" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("append")
        expect(response.body).to include("expense-list")
      end
    end

    context "with invalid parameters" do
      it "does not create a new expense" do
        expect {
          post "/users/#{user.id}/expenses", params: {expense: invalid_attributes}
        }.to change(Expense, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{user.id}/expenses", params: {expense: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch "/users/#{user.id}/expenses/#{expense.id}", params: {expense: valid_attributes}
      end

      it "updates the requested time_request" do
        expense.reload
        expect(expense.date).to eq(Date.new(2023, 05, 22))
        expect(expense.category).to eq("travel")
        expect(expense.description).to eq("My description is too long.")
        expect(expense.amount).to eq(145.45)
      end

      it "successfully updates expense" do
        expense.reload
        expect(response).to have_http_status(:ok)
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}/expenses/#{expense.id}", params: {expense: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update_status" do
    before do
      patch user_update_status_expense_path(user_id: user.id, id: expense.id, status: "approved")
    end

    it "updates the expense status" do
      expense.reload
      expect(expense.status).to eq("approved")
    end
    
    it "redirects to the expense" do
      expect(response).to redirect_to(user_expense_path(user, expense))
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.status_successfully_updated"))
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /delete_receipt" do
    before do
      expense.receipts.attach(io: File.open("#{Rails.root}/spec/fixtures/receipt.png"), filename: 'receipt.png', content_type: "image/png")
      receipt = expense.receipts.last
      delete user_delete_receipt_expense_path(user_id: user.id, id: expense.id, receipt_id: receipt.id)
    end

    it "deletes the receip" do
      expect(expense.receipts.count).to eq(0)
    end

    it "redirects to the expense" do
      expect(response).to redirect_to(user_expense_path(user, expense))
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.receipt_successfully_deleted"))
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end
end
