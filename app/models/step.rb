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
class Step < ApplicationRecord
  belongs_to :course
  belongs_to :stepable, polymorphic: true
  has_many :user_progresses, as: :progressable

  def next_step
    course = Course.find(course_id)
    steps = Course.find(course_id).steps
    index_plus_one = steps.index(self) + 1
    return if index_plus_one >= course.steps_count

    steps[index_plus_one]
  end
end
