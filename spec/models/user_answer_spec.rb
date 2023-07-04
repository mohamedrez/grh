require 'rails_helper'

RSpec.describe UserAnswer, type: :model do
  describe "#create_question_answers" do
    let(:review) { create(:review, review_type: "manager_review") }
    let(:section) { create(:section, name: "Section 1", description: "Section 1 Description", section_type: "strengths_opportunities", review_id: review.id) }

    let(:author) { create(:user) }
    let(:user) { create(:user, manager_id: author.id) }
  
    let(:user_answer) { create(:user_answer, review_id: review.id, author_id: author.id, user_id: user.id) }

    context "Providing the text_questions argumnet" do
      before do
        create(:question, id: 1, name: "Question 1", question_type: "textbox", section_id: section.id)
        user_answer.create_question_answers({"1"=>"Answer of question 1"}, nil, nil)
      end

      it 'creates a new TextResponse' do
        expect(TextResponse.count).to eq(1)
      end

      it 'creates a new QuestionAnswer' do
        expect(QuestionAnswer.count).to eq(1)
      end
    end

    context "Providing the single_select_questions argumnet" do
      before do
        question = create(:question, id: 1, name: "Question 1", question_type: "single_select", section_id: section.id)
        option1 = create(:option, id: 1, name: "Option 1", question_id: question.id)
        option2 = create(:option, id: 2, name: "Option 2", question_id: question.id)

        user_answer.create_question_answers(nil, {"1"=>"1"}, nil)
      end

      it 'creates a new SingleSelectResponse' do
        expect(SingleSelectResponse.count).to eq(1)
      end

      it 'creates a new QuestionAnswer' do
        expect(QuestionAnswer.count).to eq(1)
      end
    end

    context "Providing the single_select_questions argumnet" do
      before do
        question = create(:question, id: 1, name: "Question 1", question_type: "multiple_select", section_id: section.id)
        option1 = create(:option, id: 1, name: "Option 1", question_id: question.id)
        option2 = create(:option, id: 2, name: "Option 2", question_id: question.id)

        user_answer.create_question_answers(nil, nil, {"1"=>{"1"=>"1", "2"=>"2"}})
      end

      it 'creates a new MultipleSelectResponse' do
        expect(MultipleSelectResponse.count).to eq(1)
      end

      it 'creates a new SingleSelectResponse' do
        expect(MultipleSelectOption.count).to eq(2)
      end

      it 'creates a new QuestionAnswer' do
        expect(QuestionAnswer.count).to eq(1)
      end
    end
  end
end
