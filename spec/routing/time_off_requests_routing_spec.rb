require "rails_helper"

RSpec.describe TimeOffRequestsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/time_off_requests").to route_to("time_off_requests#index")
    end

    it "routes to #new" do
      expect(get: "/time_off_requests/new").to route_to("time_off_requests#new")
    end

    it "routes to #show" do
      expect(get: "/time_off_requests/1").to route_to("time_off_requests#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/time_off_requests/1/edit").to route_to("time_off_requests#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/time_off_requests").to route_to("time_off_requests#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/time_off_requests/1").to route_to("time_off_requests#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/time_off_requests/1").to route_to("time_off_requests#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/time_off_requests/1").to route_to("time_off_requests#destroy", id: "1")
    end
  end
end
