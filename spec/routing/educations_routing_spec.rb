require "rails_helper"

RSpec.describe EducationsController, type: :routing do
  describe "routing" do
    xit "routes to #index" do
      expect(get: "/educations").to route_to("educations#index")
    end

    xit "routes to #new" do
      expect(get: "/educations/new").to route_to("educations#new")
    end

    xit "routes to #show" do
      expect(get: "/educations/1").to route_to("educations#show", id: "1")
    end

    xit "routes to #edit" do
      expect(get: "/educations/1/edit").to route_to("educations#edit", id: "1")
    end

    xit "routes to #create" do
      expect(post: "/educations").to route_to("educations#create")
    end

    xit "routes to #update via PUT" do
      expect(put: "/educations/1").to route_to("educations#update", id: "1")
    end

    xit "routes to #update via PATCH" do
      expect(patch: "/educations/1").to route_to("educations#update", id: "1")
    end

    xit "routes to #destroy" do
      expect(delete: "/educations/1").to route_to("educations#destroy", id: "1")
    end
  end
end
