require "rails_helper"

RSpec.describe "experiences/edit", type: :view do
  let(:experience) {
    Experience.create!(
      job_title: "MyString",
      company_name: "MyString",
      employment_type: 1,
      work_description: "MyText",
      user: nil
    )
  }

  before(:each) do
    assign(:experience, experience)
  end

  it "renders the edit experience form" do
    render

    assert_select "form[action=?][method=?]", experience_path(experience), "post" do
      assert_select "input[name=?]", "experience[job_title]"

      assert_select "input[name=?]", "experience[company_name]"

      assert_select "input[name=?]", "experience[employment_type]"

      assert_select "textarea[name=?]", "experience[work_description]"

      assert_select "input[name=?]", "experience[user_id]"
    end
  end
end
