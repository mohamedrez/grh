require 'rails_helper'

RSpec.describe "experiences/new", type: :view do
  before(:each) do
    assign(:experience, Experience.new(
      job_title: "MyString",
      company_name: "MyString",
      employment_type: 1,
      work_description: "MyText",
      user: nil
    ))
  end

  it "renders new experience form" do
    render

    assert_select "form[action=?][method=?]", experiences_path, "post" do

      assert_select "input[name=?]", "experience[job_title]"

      assert_select "input[name=?]", "experience[company_name]"

      assert_select "input[name=?]", "experience[employment_type]"

      assert_select "textarea[name=?]", "experience[work_description]"

      assert_select "input[name=?]", "experience[user_id]"
    end
  end
end
