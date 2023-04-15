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
end
