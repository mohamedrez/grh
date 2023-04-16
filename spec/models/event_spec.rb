require 'rails_helper'

RSpec.describe Event, type: :model do

  describe 'color' do
    let(:event) { create :event, eventable: eventable }
    let(:eventable) { create :time_off_request }

    it 'returns color for event' do
      expect(event.color).to eq('#853131')
    end
  end

end
