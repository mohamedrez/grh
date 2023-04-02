require 'rails_helper'

RSpec.describe "educations/index", type: :view do
  before(:each) do
    assign(:educations, [
      Education.create!(
        school: "School",
        country: 2,
        city: "City",
        education_level: 3,
        study_field: 4,
        still_on_this_course: false,
        user: nil
      ),
      Education.create!(
        school: "School",
        country: 2,
        city: "City",
        education_level: 3,
        study_field: 4,
        still_on_this_course: false,
        user: nil
      )
    ])
  end

  it "renders a list of educations" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("School".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
