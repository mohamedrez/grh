require 'rails_helper'

RSpec.describe "educations/show", type: :view do
  before(:each) do
    assign(:education, Education.create!(
      school: "School",
      country: 2,
      city: "City",
      education_level: 3,
      study_field: 4,
      still_on_this_course: false,
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/School/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
