class JobApplication < ApplicationRecord
  validates :first_name, :last_name, :email, :phone, presence: true
  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\ -]+(\.[a-z\d\ -]+)*\.[a-z]+\z/i}
  has_one_attached :resume, dependent: :destroy
end
