require 'rails_helper'

RSpec.describe "time_off_requests/show", type: :view do
  before(:each) do
    assign(:time_off_request, TimeOffRequest.create!(
      content: nil,
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
