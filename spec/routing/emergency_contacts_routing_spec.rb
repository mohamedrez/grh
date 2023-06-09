require "rails_helper"

RSpec.describe EmergencyContactsController, type: :routing do
  describe "routing" do
    xit "routes to #index" do
      expect(get: "/emergency_contacts").to route_to("emergency_contacts#index")
    end

    xit "routes to #new" do
      expect(get: "/emergency_contacts/new").to route_to("emergency_contacts#new")
    end

    xit "routes to #show" do
      expect(get: "/emergency_contacts/1").to route_to("emergency_contacts#show", id: "1")
    end

    xit "routes to #edit" do
      expect(get: "/emergency_contacts/1/edit").to route_to("emergency_contacts#edit", id: "1")
    end

    xit "routes to #create" do
      expect(post: "/emergency_contacts").to route_to("emergency_contacts#create")
    end

    xit "routes to #update via PUT" do
      expect(put: "/emergency_contacts/1").to route_to("emergency_contacts#update", id: "1")
    end

    xit "routes to #update via PATCH" do
      expect(patch: "/emergency_contacts/1").to route_to("emergency_contacts#update", id: "1")
    end

    xit "routes to #destroy" do
      expect(delete: "/emergency_contacts/1").to route_to("emergency_contacts#destroy", id: "1")
    end
  end
end
