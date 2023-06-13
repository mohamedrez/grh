require "rails_helper"

RSpec.describe "/sites", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:site) { create(:site) }

  let(:valid_attributes) do
    {
      name: "Site1",
      code: "DSD",
      phone: "(602) 496-4636",
      address: "411 N Central Ave, Phoenix, AZ 850"
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      code: "DSD",
      phone: "(602) 496-4636",
      address: "411 N Central Ave, Phoenix, AZ 850"
    }
  end

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get sites_path
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_site_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_site_url(id: site.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Site" do
        expect {
          post sites_url, params: {site: valid_attributes}
        }.to change(Site, :count).by(1)
      end

      before do
        post sites_url, params: {site: valid_attributes}
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("append")
        expect(response.body).to include("sites")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Site" do
        expect {
          post sites_url, params: {site: invalid_attributes}
        }.to change(Site, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post sites_url, params: {site: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch site_url(id: site.id), params: {site: valid_attributes}
      end

      it "updates the requested site" do
        site.reload
        expect(site.name).to eq("Site1")
        expect(site.code).to eq("DSD")
        expect(site.phone).to eq("(602) 496-4636")
        expect(site.address).to eq("411 N Central Ave, Phoenix, AZ 850")
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch site_url(id: site.id), params: {site: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE /destroy' do
      before do
        delete site_path(id: site.id)
      end
      
      it 'destroy the site' do
        expect(Site.count).to eq(0)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
      end
    end
  end
end
