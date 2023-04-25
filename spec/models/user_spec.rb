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
require "rails_helper"

RSpec.describe(User, type: :model) do
  let(:user) { create(:user) }

  describe "#full_name" do
    it 'returns the full name' do
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe ".search" do
    it 'returns nil' do
      query = nil
      expect(User.search(query)).to eq(nil)
    end

    it 'returns a hash containing last_name_cont value' do
      query = { last_name_or_email_or_employee_number_cont: "vi" }
      expect(User.search(query)).to eq({"last_name_cont" => "vi"})
    end

    it 'returns a hash containing email_cont value' do
      query = { last_name_or_email_or_employee_number_cont: "vi@me.com" }
      expect(User.search(query)).to eq({"email_cont" => "vi@me.com"})
    end

    it 'returns a hash containing employee_number_cont value' do
      query = { last_name_or_email_or_employee_number_cont: "5432157" }
      expect(User.search(query)).to eq({"employee_number_cont" => "5432157"})
    end
  end

  describe ".import" do
    let(:file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/test_users.csv", 'text/csv') }

    context "when a valid file is given" do
      it "creates new users" do
        expect {
          User.import(file)
        }.to change(User, :count).by(2)
      end

      it "creates users with the correct attributes" do
        User.import(file)

        user1 = User.find_by(email: "jdoe@example.com")
        expect(user1.first_name).to eq("John")
        expect(user1.last_name).to eq("Doe")
        expect(user1.birthdate).to eq(Date.new(1990, 1, 1))
        expect(user1.start_date).to eq(Date.new(2020, 1, 1))
        expect(user1.end_date).to eq(Date.new(2022, 12, 31))
        expect(user1.cnss_number).to eq("1234567890")
        expect(user1.employee_number).to eq("1001")
        expect(user1.address.street).to eq("123 Main St")
        expect(user1.address.city).to eq("Anytown")
        expect(user1.address.zipcode).to eq("12345")
        expect(user1.address.country).to eq("morocco")

        user2 = User.find_by(email: "jsmith@example.com")
        expect(user2.first_name).to eq("Jane")
        expect(user2.last_name).to eq("Smith")
        expect(user2.birthdate).to eq(Date.new(1985, 5, 20))
        expect(user2.start_date).to eq(Date.new(2019, 5, 1))
        expect(user2.end_date).to eq(Date.new(2023, 6, 30))
        expect(user2.cnss_number).to eq("0987654321")
        expect(user2.employee_number).to eq("1002")
        expect(user2.address.street).to eq("456 Oak Ave")
        expect(user2.address.city).to eq("Anycity")
        expect(user2.address.zipcode).to eq("54321")
        expect(user2.address.country).to eq("morocco")
      end
    end
  end
end
