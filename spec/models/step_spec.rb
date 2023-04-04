# frozen_string_literal: true

# == Schema Information
#
# Table name: steps
#
#  id            :bigint           not null, primary key
#  course_id     :bigint           not null
#  position      :integer
#  stepable_type :string(255)      not null
#  stepable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string(255)
#
require "rails_helper"

RSpec.describe(Step, type: :model) do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)

    @track = FactoryBot.create(:track)

    @course = FactoryBot.create(:course, track: @track)

    @lecture = FactoryBot.create(:lecture, youtube_video_link: "https://www.youtube.com/watch?v=u8tagI3wlp4")
    @quiz = FactoryBot.create(:quiz)

    @step1 = FactoryBot.create(:step, course: @course, stepable: @lecture, position: 0)
    @step2 = FactoryBot.create(:step, course: @course, stepable: @quiz, position: 1)

    @up1 = FactoryBot.create(:user_progress, status: :completed, progressable: @step1, user: @user2)
  end

  describe "#next_step" do
    it "returns the next step because it exists" do
      expect(@step1.next_step).to eql(@step2)
    end

    it "returns null because this step is the last one" do
      expect(@step2.next_step).to eql(nil)
    end
  end

  describe "#previous_step" do
    it "returns null because this step is the first one" do
      expect(@step1.previous_step).to eql(nil)
    end

    it "returns the previous step because it exists" do
      expect(@step2.previous_step).to eql(@step1)
    end
  end

  describe "#up_status" do
    it "after creating a user progress it will returns started status" do
      expect(@step1.up_status(@user1)).to eql("started")
    end

    it "will returns completed step" do
      expect(@step1.up_status(@user2)).to eql("completed")
    end

    it "will returns started course" do
      @step1.up_status(@user1)
      expect(UserProgress.find_by!(user: @user1, progressable: @course).status).to eql("started")
    end
  end

  describe "#which_type" do
    it "returns a video bcs it's a lecture that has a video link" do
      expect(@step1.which_type).to eql("video")
    end

    xit "returns an audio bcs it's a lecture that's attached to audio_file " do
    end

    it "returns a quiz bcs it's a quiz" do
      expect(@step2.which_type).to eql("quiz")
    end
  end
end
