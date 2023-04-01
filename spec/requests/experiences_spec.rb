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

RSpec.describe "/experiences", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Experience. As you add validations to Experience, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Experience.create! valid_attributes
      get experiences_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      experience = Experience.create! valid_attributes
      get experience_url(experience)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_experience_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      experience = Experience.create! valid_attributes
      get edit_experience_url(experience)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Experience" do
        expect {
          post experiences_url, params: { experience: valid_attributes }
        }.to change(Experience, :count).by(1)
      end

      it "redirects to the created experience" do
        post experiences_url, params: { experience: valid_attributes }
        expect(response).to redirect_to(experience_url(Experience.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Experience" do
        expect {
          post experiences_url, params: { experience: invalid_attributes }
        }.to change(Experience, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post experiences_url, params: { experience: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested experience" do
        experience = Experience.create! valid_attributes
        patch experience_url(experience), params: { experience: new_attributes }
        experience.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the experience" do
        experience = Experience.create! valid_attributes
        patch experience_url(experience), params: { experience: new_attributes }
        experience.reload
        expect(response).to redirect_to(experience_url(experience))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        experience = Experience.create! valid_attributes
        patch experience_url(experience), params: { experience: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested experience" do
      experience = Experience.create! valid_attributes
      expect {
        delete experience_url(experience)
      }.to change(Experience, :count).by(-1)
    end

    it "redirects to the experiences list" do
      experience = Experience.create! valid_attributes
      delete experience_url(experience)
      expect(response).to redirect_to(experiences_url)
    end
  end
end
