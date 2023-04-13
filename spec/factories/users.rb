# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    encrypted_password { Faker::Internet.password }
    confirmed_at { Time.now.utc }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 45) }
    phone { Faker::PhoneNumber.phone_number }
    cnss_number { "124598756" }
    employee_number { "45215977" }
    job_title { Faker::Job.title }
    
    if Rails.env.development?
      site_id { Site.first.id }
    elsif Rails.env.test?
      site { FactoryBot.create(:site) }
    end
  end
end
