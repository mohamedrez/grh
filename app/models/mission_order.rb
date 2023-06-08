class MissionOrder < ApplicationRecord
  after_create :create_user_request

  belongs_to :site
  has_one :user_request, as: :requestable, dependent: :destroy
  has_rich_text :description

  enum indemnity_type: {none_indemnity_types: 0, expense_report: 1, flat_rate: 2}
  enum accommodation: {none_accommodations: 0, apartment: 1, hotel: 2, other_accommodations: 3}
  enum mission_type: {none_mission_types: 0, project: 1, site: 2}
  enum transport_means: {none_transport_means: 0, car: 1, bus: 2, train: 3, motorbike: 4, taxi: 5, other_transport_means: 6}

  validates :title, :start_date, :end_date, :indemnity_type, :mission_type, :location, :transport_means, presence: true
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :indemnity_type, exclusion: {in: ["none_indemnity_types"], message: I18n.t("errors.not_allowing_none")}
  validates :mission_type, exclusion: {in: ["none_mission_types"], message: I18n.t("errors.not_allowing_none")}
  validates :transport_means, exclusion: {in: ["none_transport_means"], message: I18n.t("errors.not_allowing_none")}

  delegate :user, to: :user_request

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end
end
