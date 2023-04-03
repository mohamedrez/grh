require "rails_helper"

RSpec.describe "time_off_requests/index", type: :view do
  before(:each) do
    assign(:time_off_requests, [
      TimeOffRequest.create!(
        content: nil
      ),
      TimeOffRequest.create!(
        content: nil
      )
    ])
  end

  it "renders a list of time_off_requests" do
    render
    # cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
  end
end
