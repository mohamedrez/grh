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
        }.to change(User, :count).by(3)
      end

      it "creates users with the correct attributes" do
        User.import(file)

        user1 = User.find_by(email: "user1@example.com")
        expect(user1.first_name).to eq("John")
        expect(user1.last_name).to eq("Doe")
        expect(user1.birthdate).to eq(Date.new(1990, 1, 1))
        expect(user1.start_date).to eq(Date.new(2021, 1, 1))
        expect(user1.end_date).to eq(Date.new(2022, 1, 1))
        expect(user1.cnss_number).to eq("12345678")
        expect(user1.employee_number).to eq("1")

        user2 = User.find_by(email: "user2@example.com")
        expect(user2.first_name).to eq("Jane")
        expect(user2.last_name).to eq("Doe")
        expect(user2.birthdate).to eq(Date.new(1995, 6, 15))
        expect(user2.start_date).to eq(Date.new(2022, 1, 1))
        expect(user2.end_date).to eq(Date.new(2022, 12, 31))
        expect(user2.cnss_number).to eq("987654321")
        expect(user2.employee_number).to eq("2")

        user3 = User.find_by(email: "user3@example.com")
        expect(user3.first_name).to eq("Michael")
        expect(user3.last_name).to eq("Johnson")
        expect(user3.birthdate).to eq(Date.new(1985, 3, 20))
        expect(user3.start_date).to eq(Date.new(2022, 1, 1))
        expect(user3.end_date).to eq(Date.new(2022, 12, 31))
        expect(user3.cnss_number).to eq("567890123")
        expect(user3.employee_number).to eq("3")
      end
    end
  end
end
