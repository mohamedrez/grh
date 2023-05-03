require "rails_helper"

RSpec.describe TimeRequestsController, type: :routing do
  describe "routing" do
    xit "routes to #index" do
      expect(get: "/time_requests").to route_to("time_requests#index")
    end

    xit "routes to #new" do
      expect(get: "/time_requests/new").to route_to("time_requests#new")
    end

    xit "routes to #show" do
      expect(get: "/time_requests/1").to route_to("time_requests#show", id: "1")
    end

    xit "routes to #edit" do
      expect(get: "/time_requests/1/edit").to route_to("time_requests#edit", id: "1")
    end

    xit "routes to #create" do
      expect(post: "/time_requests").to route_to("time_requests#create")
    end

    xit "routes to #update via PUT" do
      expect(put: "/time_requests/1").to route_to("time_requests#update", id: "1")
    end

    xit "routes to #update via PATCH" do
      expect(patch: "/time_requests/1").to route_to("time_requests#update", id: "1")
    end

    xit "routes to #destroy" do
      expect(delete: "/time_requests/1").to route_to("time_requests#destroy", id: "1")
    end
  end
end
