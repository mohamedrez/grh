require "rails_helper"

RSpec.describe ExperiencesController, type: :routing do
  describe "routing" do
    xit "routes to #index" do
      expect(get: "/experiences").to route_to("experiences#index")
    end

    xit "routes to #new" do
      expect(get: "/experiences/new").to route_to("experiences#new")
    end

    xit "routes to #show" do
      expect(get: "/experiences/1").to route_to("experiences#show", id: "1")
    end

    xit "routes to #edit" do
      expect(get: "/experiences/1/edit").to route_to("experiences#edit", id: "1")
    end

    xit "routes to #create" do
      expect(post: "/experiences").to route_to("experiences#create")
    end

    xit "routes to #update via PUT" do
      expect(put: "/experiences/1").to route_to("experiences#update", id: "1")
    end

    xit "routes to #update via PATCH" do
      expect(patch: "/experiences/1").to route_to("experiences#update", id: "1")
    end

    xit "routes to #destroy" do
      expect(delete: "/experiences/1").to route_to("experiences#destroy", id: "1")
    end
  end
end
