require 'rails_helper'

RSpec.describe "time_off_requests/edit", type: :view do
  let(:time_off_request) {
    TimeOffRequest.create!(
      content: nil,
      user: nil
    )
  }

  before(:each) do
    assign(:time_off_request, time_off_request)
  end

  it "renders the edit time_off_request form" do
    render

    assert_select "form[action=?][method=?]", time_off_request_path(time_off_request), "post" do

      assert_select "input[name=?]", "time_off_request[content]"

      assert_select "input[name=?]", "time_off_request[user_id]"
    end
  end
end
