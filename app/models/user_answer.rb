class UserAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :answerable, polymorphic: true

  def self.create_user_answers(user, text_questions, single_select_questions, multiple_select_questions)
    text_questions&.each do |question_id, content|
      if content.present?
        text_response = TextResponse.create!(content: content)
        UserAnswer.create!(question_id: question_id, user_id: user.id, answerable: text_response)
      end
    end

    single_select_questions&.each do |question_id, option_id|
      single_select_response = SingleSelectResponse.create!(option_id: option_id)
      UserAnswer.create!(question_id: question_id, user_id: user.id, answerable: single_select_response)
    end

    multiple_select_questions&.each do |question_id, value|
      multiple_select_response = MultipleSelectResponse.create!

      value.each do |option_id_key, option_id_value|
        MultipleSelectOption.create(multiple_select_response_id: multiple_select_response.id, option_id: option_id_key)
      end

      UserAnswer.create!(question_id: question_id, user_id: user.id, answerable: multiple_select_response)
    end
  end
end
