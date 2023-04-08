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
  before do
    @user1 = FactoryBot.create(:user, first_name: "tim")
    @user2 = FactoryBot.create(:user, first_name: "corey")
    @user3 = FactoryBot.create(:user, first_name: "james")
  end

  describe ".search" do
    it "returns the filtered name" do
      params = {query: "m"}
      expect(User.search(params).count).to eql(2)
      expect(User.search(params).first).to eql(@user1)
      expect(User.search(params).last).to eql(@user3)
    end
  end
end
