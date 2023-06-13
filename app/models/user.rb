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
    :confirmable

  has_one_attached :avatar, dependent: :destroy
  has_rich_text :about

  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :subordinates, class_name: "User", foreign_key: "manager_id", dependent: :destroy, inverse_of: :manager
  has_many :emergency_contacts, dependent: :destroy
  has_many :announcements, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :task, dependent: :destroy
  has_many :roles, dependent: :destroy

  has_many :review_users, dependent: :destroy
  has_many :reviews, through: :review_users

  has_one :address, dependent: :destroy

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :site, optional: true

  validates :first_name, :last_name, presence: true
  validates :cnss_number, :employee_number, numericality: {only_integer: true, allow_blank: true}
  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\ -]+(\.[a-z\d\ -]+)*\.[a-z]+\z/i}

  accepts_nested_attributes_for :address, update_only: true
  accepts_nested_attributes_for :experiences
  accepts_nested_attributes_for :educations

  enum :gender, %i[male female], prefix: :user_gender
  enum :marital_status, %i[single married divorced other], prefix: :user_marital_status
  enum :service, %i[financial healthcare information_technology marketing_and_advertising], prefix: :user_service
  enum :job_title, %i[operations finance human_resource marketing sale information_technology research_and_development administration], prefix: :user_job_title
  enum :contract, %i[CDD CDI Intern], prefix: :user_contract
  enum :category, %i[cadre non_cadre], prefix: :user_category

  def avatar_url_or_default
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        avatar, only_path: true
      )
    else
      "users/user.png"
    end
  end

  def has_role?(role_name)
    roles.any? { |role| role.name.to_sym == role_name.to_sym }
  end

  def has_any_role?(role_names)
    roles.any? { |role| role_names.include?(role.name.to_sym) }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "first_name", "last_name", "employee_number", "first_name_or_last_name_or_email_or_employee_number_cont"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["address", "avatar_attachment", "avatar_blob", "educations", "emergency_contacts", "experiences", "manager", "notifications", "rich_text_about", "site", "subordinates", "user_points", "user_progresses", "user_quiz_responses", "user_requests"]
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = User.find_or_create_by!(email: row["email"]) do |user|
        user.password = Devise.friendly_token.first(8)
        user.confirmed_at = Time.now.utc
        user.first_name = row["first_name"]
        user.last_name = row["last_name"]
        user.birthdate = Date.parse(row["birthdate"])
        user.start_date = Date.parse(row["start_date"])
        user.end_date = Date.parse(row["end_date"])
        user.cnss_number = row["cnss_number"]
        user.employee_number = row["employee_number"]
      end

      address_data = {street: row["street"], city: row["city"], zipcode: row["zipcode"], country: 6, user_id: user.id}
      Address.find_or_create_by!(address_data)
    end
  end
end
