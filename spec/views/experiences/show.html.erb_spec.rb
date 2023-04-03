require "rails_helper"

RSpec.describe "experiences/show", type: :view do
  before(:each) do
    assign(:experience, Experience.create!(
      job_title: "Job Title",
      company_name: "Company Name",
      employment_type: 2,
      work_description: "MyText",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Job Title/)
    expect(rendered).to match(/Company Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
