require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:manager) { create(:user, admin: true) }
  let(:user) { create(:user, manager_id: manager.id, admin: true) }
  let!(:time_request) { create(:time_request) } # Assuming you have a TimeRequest factory set up
  let!(:user_request) { create(:user_request, user_id: user.id, requestable: time_request) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      create :holiday
      site = create :site, name: "Site 1"
      user = create :user, service: :financial, site_id: site.id
      get "/events?service=financial&site=1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "#time_requests" do
    it "fetches and formats time requests" do
      allow(TimeRequest).to receive(:all).and_return(TimeRequest.all.includes(:user_request).includes(user_request: :user))
  
      get "/events"
  
      expect(JSON.parse(response.body, symbolize_names: true)).to eq([
        {
          id: time_request.id,
          title: time_request.user.full_name,
          type: time_request.category.humanize,
          start: time_request.start_date.to_fs(:db),
          end: time_request.end_date.to_fs(:db),
          avatar: time_request.user.avatar_url_or_default,
          color: time_request.color
        }
      ])
    end
  end
end
