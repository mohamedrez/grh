require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe "#what_is_the_status?" do
    let(:user) { create(:user, admin: true) }

    context "with nil status" do
      it "returns 'No feedback yet'" do
        goal = create(:goal, owner_id: user.id, author_id: user.id)
        expect(goal.what_is_the_status?).to eq("No feedback yet")
      end
    end

    context "with present status" do
      it "returns the status of the goal" do
        goal = create(:goal, owner_id: user.id, author_id: user.id, status: "completed")
        expect(goal.what_is_the_status?).to eq("Completed")
      end
    end
  end
end
