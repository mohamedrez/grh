# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_points, dependent: :destroy
  has_many :user_progresses, dependent: :destroy
  has_many :user_quiz_responses, dependent: :destroy
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :confirmable,
    :omniauthable, omniauth_providers: [:google_oauth2, :twitter]

  has_one_attached :avatar, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  has_one :address, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  enum :gender, %i[male female], prefix: :user
  enum :marital_status, %i[single married divorced other], prefix: :user

  accepts_nested_attributes_for :address

  has_many :subordinates, class_name: "User", foreign_key: "manager_id", dependent: :destroy, inverse_of: :manager
  belongs_to :manager, class_name: "User", optional: true
  has_rich_text :about

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar_url = auth.info.image
      user.username = auth.info.name
      user.skip_confirmation!
    end
  end

  def avatar_url_or_default
    if avatar.attached?
      avatar
    else
      "users/user.png"
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
