class TimeOffRequest < ApplicationRecord
  has_rich_text :content
  has_one :user_request, as: :requestable, dependent: :destroy

  after_create :create_user_request

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, requestable: self)
  end
end
