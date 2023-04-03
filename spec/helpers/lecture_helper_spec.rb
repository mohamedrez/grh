# frozen_string_literal: true

require "rails_helper"
require_relative "../../lib/helpers/lecture_helper"

# Specs in this file have access to a helper object that includes
# the StepsHelper. For example:
#
# describe StepsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe(LectureHelper, type: :helper) do
  include LectureHelper

  describe ".youtube_id" do
    it "return the id of a given youtube url" do
      expect(youtube_id("https://www.youtube.com/watch?v=cND5yDV1qJs&t=31s"))
        .to eql("cND5yDV1qJs")
    end
  end
end
