require "rails_helper"

RSpec.describe "/experiences", type: :request do
  let(:admin_user) { create(:user, admin: true) }
  let(:experience) { create(:experience, user_id: admin_user.id) }
  
  let(:valid_attributes) do
    {
      job_title: 'Software Developer',
      company_name: 'Acme Inc.',
      employment_type: :contractor,
      start_date: '2022-01-01',
      end_date: '2022-12-31',
      city: "New City",
      country: :usa,
      work_description: 'Worked on a variety of projects using Ruby on Rails and React'
    }
  end

  let(:invalid_attributes) do
    {
      job_title: '',
      company_name: '',
      start_date: '',
      end_date: '',
      city: "",
      work_description: 'Worked on a variety of projects using Ruby on Rails and React'
    }
  end

  before do
    sign_in admin_user
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_experience_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Experience" do
        expect {
          post user_experiences_url(user_id: admin_user.id), params: {experience: valid_attributes}
        }.to change(Experience, :count).by(1)
      end

      it "redirects to the user profile" do
        post user_experiences_url(user_id: admin_user.id), params: {experience: valid_attributes}
        expect(response).to redirect_to(user_url(admin_user))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Experience" do
        expect {
          post user_experiences_url(user_id: admin_user.id), params: {experience: invalid_attributes}
        }.to change(Experience, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post user_experiences_url(user_id: admin_user.id), params: {experience: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
