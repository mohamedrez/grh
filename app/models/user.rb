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
  has_rich_text :about

  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :subordinates, class_name: "User", foreign_key: "manager_id", dependent: :destroy, inverse_of: :manager

  has_one :address, dependent: :destroy

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :site, optional: true

  validates :first_name, :last_name, presence: true
  validates :cnss_number, :employee_number, numericality: {only_integer: true, allow_blank: true}

  accepts_nested_attributes_for :address, update_only: true

  enum :gender, %i[male female], prefix: :user_gender
  enum :marital_status, %i[single married divorced other], prefix: :user_marital_status
  enum :service, %i[financial healthcare information_technology marketing_and_advertising], prefix: :user_service
  enum :job_title, %i[operations finance human_resource marketing sale information_technology research_and_development administration], prefix: :user_job_title
  enum :contract, %i[CDD CDI Intern], prefix: :user_contract
  enum :category, %i[cadre non_cadre], prefix: :user_category

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

  def self.search(query)
    if query.blank?
      query
    else
      search = query[:last_name_or_email_or_employee_number_cont]
      search_hash(search)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "last_name", "employee_number", "last_name_or_email_or_employee_number"]
  end

  private_class_method def self.search_hash(search)
    if search.match?(/\A[a-zA-Z]+\z/)
      {"last_name_cont" => search}
    elsif search.match?(/\A[\w+.\\-]+@[a-z\d\\-]+(\.[a-z\d\\-]+)*\.[a-z]+\z/i)
      {"email_cont" => search}
    elsif search.match?(/\A\d+\z/)
      {"employee_number_cont" => search}
    end
  end
end
