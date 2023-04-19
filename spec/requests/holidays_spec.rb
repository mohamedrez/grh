require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/holidays", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Holiday. As you add validations to Holiday, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:user, admin: true) }

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Holiday.create! valid_attributes
      get holidays_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_holiday_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      holiday = Holiday.create! valid_attributes
      get edit_holiday_url(holiday)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Holiday" do
        expect {
          post holidays_url, params: { holiday: valid_attributes }
        }.to change(Holiday, :count).by(1)
      end

      it "redirects to the created holiday" do
        post holidays_url, params: { holiday: valid_attributes }
        expect(response).to redirect_to(holidays_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Holiday" do
        expect {
          post holidays_url, params: { holiday: invalid_attributes }
        }.to change(Holiday, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post holidays_url, params: { holiday: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested holiday" do
        holiday = Holiday.create! valid_attributes
        patch holiday_url(holiday), params: { holiday: new_attributes }
        holiday.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the holiday" do
        holiday = Holiday.create! valid_attributes
        patch holiday_url(holiday), params: { holiday: new_attributes }
        holiday.reload
        expect(response).to redirect_to(holidays_url)
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        holiday = Holiday.create! valid_attributes
        patch holiday_url(holiday), params: { holiday: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end
end
