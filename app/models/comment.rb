class Comment < ApplicationRecord
  belongs_to :user_request
  belongs_to :author, class_name: "User"
end
