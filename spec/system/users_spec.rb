require "rails_helper"

RSpec.feature "User management", type: :system, js: true do
  scenario "login" do
    visit "/auth/sign_in"
    user = create :user, email: "email@eila.com"
    user.password = "somepassword"
    user.save!

    fill_in "user_email", with: user.email
    fill_in "user_password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_text("Invalid Email or password.")

    fill_in "user_email", with: user.email
    fill_in "user_password", with: "somepassword"
    click_button "Log in"
    expect(page).to_not have_text("Invalid Email or password.")
    expect(page).to have_text("Signed in successfully")
  end
end
