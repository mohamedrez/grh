require 'rails_helper'

RSpec.describe "time_off_requests/index", type: :view do
  before(:each) do
    assign(:time_off_requests, [
      TimeOffRequest.create!(
        content: nil,
        user: nil
      ),
      TimeOffRequest.create!(
        content: nil,
        user: nil
      )
    ])
  end

  it "renders a list of time_off_requests" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
