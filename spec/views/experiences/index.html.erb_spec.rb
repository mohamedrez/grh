require "rails_helper"

RSpec.describe "experiences/index", type: :view do
  before(:each) do
    assign(:experiences, [
      Experience.create!(
        job_title: "Job Title",
        company_name: "Company Name",
        employment_type: 2,
        work_description: "MyText",
        user: nil
      ),
      Experience.create!(
        job_title: "Job Title",
        company_name: "Company Name",
        employment_type: 2,
        work_description: "MyText",
        user: nil
      )
    ])
  end

  it "renders a list of experiences" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new("Job Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Company Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
