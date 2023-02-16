# frozen_string_literal: true

# == Schema Information
#
# Table name: user_progresses
#
#  id                :bigint           not null, primary key
#  status            :integer
#  user_id           :bigint           not null
#  progressable_type :string(255)      not null
#  progressable_id   :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class UserProgress < ApplicationRecord
  belongs_to :user
  belongs_to :progressable, polymorphic: true

  enum status: {started: 0, completed: 1}
  after_update :user_course_progress_callback

  private

  def user_course_progress_callback
    return if status != "completed" || progressable_type != "Step"

    course_id = Step.find(progressable_id).course_id
    step_ids = Step.where(course_id:).pluck(:id)
    user_progresses = UserProgress.where(
      user_id:,
      progressable_type: "Step",
      progressable_id: step_ids,
      status: :completed
    )
    return if user_progresses.count != step_ids.count

    course = Course.find(course_id)
    usp = course.user_progresses.first_or_create!(user_id:)

    usp.update_attribute("status", :completed)
  end
end
