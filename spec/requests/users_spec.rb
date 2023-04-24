require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:site) { create(:site, id: 1) }
  let(:valid_attributes) do
    {
      first_name: "John",
      last_name: "Doe",
      about: "<div>hello everyone</div>",
      email: "me@test.com",
      phone: "12345678",
      birthdate: "02-03-1998",
      gender: "male",
      marital_status: "single",
      job_title: "RoR developer",
      start_date: "02-03-2019",
      end_date: "02-03-2024",
      site_id: site.id,
      children_number: 2,
      cin: "ZWE452GH",
      service: :financial,
      job_title: :sale,
      joining_date: Date.new(2023, 4, 14),
      contract: :CDI,
      category: :cadre,
      cnss_number: "4521879564",
      employee_number: "3397701296",
      brut_salary: 11000,
      net_salary: 8000,
      cnss_contribution: 1000,
      retirement_contribution: 2000,
      pto_number: 23,
      address_attributes:
      {
        street: "123 Main St",
        country: "usa",
        city: "New York",
        zipcode: "42157"
      }
    }
  end
  let(:invalid_attributes) do
    {
      first_name: "",
      last_name: "",
      phone: "",
      birthdate: "",
      cnss_number: "45TH8977HFGH",
      employee_number: "3397OJUU796",
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get "/users/#{user.id}"
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get "/users/new"
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get "/users/#{user.id}/edit"
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post "/users", params: {user: valid_attributes}
        }.to change(User, :count).by(1)
      end

      it "redirects to the created User" do
        post "/users", params: {user: valid_attributes}
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post "/users", params: {user: invalid_attributes}
        }.to change(User, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users", params: {user: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested user" do
        patch "/users/#{user.id}", params: {user: valid_attributes}
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

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}", params: {user: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /import' do
    context 'with valid file' do
      let(:file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/test_users.csv", 'text/csv') }


      it 'imports the users' do
        post import_users_path, params: { file: file }

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq(I18n.t('flash.successfully_imported'))
      end
    end

    context 'with missing file' do
      it 'returns an error message' do
        post import_users_path

        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to eq(I18n.t('flash.please_select_file'))
      end
    end
  end
end
