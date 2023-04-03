class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :managed_by, class_name: "User", optional: true
  belongs_to :requestable, polymorphic: true

  def path
    polymorphic_url(requestable)
  end

end
