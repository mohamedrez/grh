require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  it 'returns the correct button class for each goal status' do
    goal = double('Goal')

    allow(goal).to receive(:status).and_return(nil)
    expect(button_class_for_goal_status(goal)).to eq('bg-gray-50 text-gray-700 ring-gray-600/10')

    allow(goal).to receive(:status).and_return('incomplete')
    expect(button_class_for_goal_status(goal)).to eq('bg-red-50 text-red-700 ring-red-600/10')

    allow(goal).to receive(:status).and_return('completed')
    expect(button_class_for_goal_status(goal)).to eq('bg-green-50 text-green-700 ring-green-600/10')

    allow(goal).to receive(:status).and_return('overpass')
    expect(button_class_for_goal_status(goal)).to eq('bg-indigo-50 text-indigo-700 ring-indigo-600/10')
  end
end
