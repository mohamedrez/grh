require "rails_helper"

RSpec.describe "educations/edit", type: :view do
  let(:education) {
    Education.create!(
      school: "MyString",
      country: 1,
      city: "MyString",
      education_level: 1,
      study_field: 1,
      still_on_this_course: false,
      user: nil
    )
  }

  before(:each) do
    assign(:education, education)
  end

  it "renders the edit education form" do
    render

    assert_select "form[action=?][method=?]", education_path(education), "post" do
      assert_select "input[name=?]", "education[school]"

      assert_select "input[name=?]", "education[country]"

      assert_select "input[name=?]", "education[city]"

      assert_select "input[name=?]", "education[education_level]"

      assert_select "input[name=?]", "education[study_field]"

      assert_select "input[name=?]", "education[still_on_this_course]"

      assert_select "input[name=?]", "education[user_id]"
    end
  end
end
