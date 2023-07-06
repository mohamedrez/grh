require 'rails_helper'

RSpec.describe Job, type: :model do
  describe "#color_badge" do
    it "returns 'green-badge' when status is 'open'" do
      status = "open"
      result = Job.new.color_badge(status)
      expect(result).to eq("green-badge")
    end

    it "returns 'red-badge' when status is not 'open'" do
      status = "closed"
      result = Job.new.color_badge(status)
      expect(result).to eq("red-badge")
    end
  end
end
