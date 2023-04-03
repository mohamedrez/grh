# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  track_id   :bigint           not null
#  name       :string(255)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe(Course, type: :model) do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)

    @track = FactoryBot.create(:track)
    @course = FactoryBot.create(:course, track: @track)

    @lecture1 = FactoryBot.create(:lecture)
    @lecture2 = FactoryBot.create(:lecture)

    @step1 = FactoryBot.create(:step, course: @course, stepable: @lecture1, id: 1)
    @step2 = FactoryBot.create(:step, course: @course, stepable: @lecture2, id: 2)

    @up1 = FactoryBot.create(:user_progress, status: :completed, progressable: @step1, user: @user1)
    @up2 = FactoryBot.create(:user_progress, status: :started, progressable: @step2, user: @user1)
    @up3 = FactoryBot.create(:user_progress, status: :completed, progressable: @step1, user: @user2)
    @up4 = FactoryBot.create(:user_progress, status: :completed, progressable: @step2, user: @user2)
  end

  describe "#get_steps_status" do
    it "get a hash with {step_id: status}" do
      expect(@course.get_steps_status(@user1)).to eql({1 => "completed", 2 => "started"})
      expect(@course.get_steps_status(@user2)).to eql({1 => "completed", 2 => "completed"})
    end
  end
end
