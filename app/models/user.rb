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

  # has_many :job_applications, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :user_requests, dependent: :destroy
  has_many :subordinates, class_name: "User", foreign_key: "manager_id", dependent: :destroy, inverse_of: :manager
  has_many :emergency_contacts, dependent: :destroy
  has_many :announcements, dependent: :destroy
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
  validate :check_manager

  accepts_nested_attributes_for :address, update_only: true

  enum gender: {male: 0, female: 1}
  enum marital_status: {single: 0, married: 1, divorced: 2, other_marital_status: 3}
  enum service: {financial: 0, healthcare: 1, information_technology: 2, marketing_and_advertising: 3, other_service: 4}, _prefix: :service
  enum job_title: UsersHelper.job_titles
  enum contract: {cdd: 0, cdi: 1, intern: 2, other_contract: 3}
  enum category: {cadre: 0, non_cadre: 1}

  def avatar_url_or_default
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        avatar, only_path: true
      )
    else
      "users/user.png"
    end
  end

  def check_manager
    if manager && manager.manager == self
      errors.add(:manager_id, "the #{manager.full_name} cannot be your manager because you are his manager.")
    elsif manager == self
      errors.add(:manager_id, "You cannot assign yourself as your own manager")
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
