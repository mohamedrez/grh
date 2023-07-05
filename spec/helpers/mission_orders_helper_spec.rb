require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MissionOrdersHelper. For example:
#
# describe MissionOrdersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MissionOrdersHelper, type: :helper do
  describe '#button_classes' do
    it 'returns the correct button classes for each state' do
      expect(button_classes(:reject)).to eq('bg-red-500 hover:bg-red-400')
      expect(button_classes(:pay_by_accountant)).to eq('bg-green-500 hover:bg-green-400')
      expect(button_classes(:pay_by_holding_treasury)).to eq('bg-green-500 hover:bg-green-400')
      expect(button_classes(:validate_by_manager)).to eq('bg-indigo-500 hover:bg-indigo-400')
      expect(button_classes(:validate_by_hr)).to eq('bg-indigo-500 hover:bg-indigo-400')
    end

    it 'returns nil for unsupported states' do
      expect(button_classes(:some_state)).to be_nil
    end
  end
end
