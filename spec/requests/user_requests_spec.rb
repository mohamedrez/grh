require "rails_helper"

RSpec.describe "UserRequests", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:time_off_request) { create(:time_off_request, user_id: user.id, start_date: Date.today, end_date: (Date.today + 7)) }

  before do
    sign_in user
  end

  describe "PATCH /update" do
    it "approved the request" do
      patch "/users/#{user.id}", params: {user: valid_attributes}
      patch user_user_request_update_path(user_id: user.id, id: time_off_request.user_request.id, managed_by_id: user.id, state: :approved)
      user.reload

      expect(user.first_name).to eq("John")
      expect(user.last_name).to eq("Doe")
      expect(user.about).to eq(user.about)
      expect(user.phone).to eq("12345678")
      expect(user.gender).to eq("male")
      expect(user.marital_status).to eq("single")
      expect(user.start_date).to eq(Date.new(2019, 3, 2))
      expect(user.birthdate).to eq(Date.new(1998, 3, 2))
      expect(user.end_date).to eq(Date.new(2024, 3, 2))
      expect(user.site_id).to eq(1)
      expect(user.children_number).to eq(2)
      expect(user.cin).to eq("ZWE452GH")
      expect(user.service).to eq("financial")
      expect(user.job_title).to eq("sale")
      expect(user.joining_date).to eq(Date.new(2023, 4, 14))
      expect(user.contract).to eq("CDI")
      expect(user.category).to eq("cadre")
      expect(user.cnss_number).to eq("4521879564")
      expect(user.employee_number).to eq("3397701296")
      expect(user.brut_salary).to eq(11000)
      expect(user.net_salary).to eq(8000)
      expect(user.cnss_contribution).to eq(1000)
      expect(user.retirement_contribution).to eq(2000)
      expect(user.pto_number).to eq(23)

      expect(user.address.street).to eq("123 Main St")
      expect(user.address.country).to eq("usa")
      expect(user.address.city).to eq("New York")
      expect(user.address.zipcode).to eq("42157")
    end

    it "redirects to the user" do
      patch "/users/#{user.id}", params: {user: valid_attributes}
      user.reload
      expect(response).to redirect_to(user_url(user))
    end
  end
end
