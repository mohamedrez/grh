require 'rails_helper'

RSpec.describe CommentSubscriber, type: :model do
  describe "create" do
    context "when a comment is created" do
      it "sends an email to the user's manager" do
        manager = create(:user)
        user = create(:user, manager_id: manager.id)
        user_request = create(:time_request, user_id: user.id).user_request
        ActionMailer::Base.deliveries.clear
        comment = create(:comment, author_id: user.id, commentable: user_request)
        expect(ActionMailer::Base.deliveries.last.to.first).to eq(manager.email)
        expect(ActionMailer::Base.deliveries.count).to eq(1)

        #when the manager replies to the comment only the user should receive the email
        comment = create(:comment, author_id: manager.id, commentable: user_request)
        expect(ActionMailer::Base.deliveries.count).to eq(2)
        expect(ActionMailer::Base.deliveries.last.to.first).to eq(user.email)

        # when another user replies in the same thread
        another_user = create(:user)
        ActionMailer::Base.deliveries.clear
        comment = create(:comment, author_id: another_user.id, commentable: user_request)
        expect(ActionMailer::Base.deliveries.count).to eq(2)
        expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(user.email)
        expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(manager.email)
      end
    end
  end
end
