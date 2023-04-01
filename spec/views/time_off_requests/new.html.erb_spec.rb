require 'rails_helper'

RSpec.describe "time_off_requests/new", type: :view do
  before(:each) do
    assign(:time_off_request, TimeOffRequest.new(
      content: nil,
      user: nil
    ))
  end

  it "renders new time_off_request form" do
    render

    assert_select "form[action=?][method=?]", time_off_requests_path, "post" do

      assert_select "input[name=?]", "time_off_request[content]"

      assert_select "input[name=?]", "time_off_request[user_id]"
    end
  end
end
