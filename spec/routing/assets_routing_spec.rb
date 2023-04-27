require "rails_helper"

RSpec.describe AssetsController, type: :routing do
  describe "routing" do
    xit "routes to #index" do
      expect(get: "/assets").to route_to("assets#index")
    end

    xit "routes to #new" do
      expect(get: "/assets/new").to route_to("assets#new")
    end

    xit "routes to #show" do
      expect(get: "/assets/1").to route_to("assets#show", id: "1")
    end

    xit "routes to #edit" do
      expect(get: "/assets/1/edit").to route_to("assets#edit", id: "1")
    end


    xit "routes to #create" do
      expect(post: "/assets").to route_to("assets#create")
    end

    xit "routes to #update via PUT" do
      expect(put: "/assets/1").to route_to("assets#update", id: "1")
    end

    xit "routes to #update via PATCH" do
      expect(patch: "/assets/1").to route_to("assets#update", id: "1")
    end

    xit "routes to #destroy" do
      expect(delete: "/assets/1").to route_to("assets#destroy", id: "1")
    end
  end
end
