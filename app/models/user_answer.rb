class UserAnswer < ApplicationRecord
  belongs_to :review
  belongs_to :author, class_name: "User"
  belongs_to :user

  has_many :question_answers, dependent: :destroy

  def create_question_answers(text_questions, single_select_questions, multiple_select_questions)
    text_questions&.each do |question_id, content|
      if content.present?
        text_response = TextResponse.create!(content: content)
        QuestionAnswer.create!(user_answer: self, question_id: question_id, answerable: text_response)
      end
    end

    single_select_questions&.each do |question_id, option_id|
      single_select_response = SingleSelectResponse.create!(option_id: option_id)
      QuestionAnswer.create!(user_answer: self, question_id: question_id, answerable: single_select_response)
    end

    multiple_select_questions&.each do |question_id, value|
      multiple_select_response = MultipleSelectResponse.create!

      value.each do |option_id_key, option_id_value|
        MultipleSelectOption.create(multiple_select_response_id: multiple_select_response.id, option_id: option_id_key)
      end

      QuestionAnswer.create!(user_answer: self, question_id: question_id, answerable: multiple_select_response)
    end
  end
end
