# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Track
    can :read, Course
    can :read, Step
    can :create, UserQuizResponse
    can :read, :home
    can :read, :dashboard

    return if user.blank?
    can :update, UserProgress, user: user
    can :update, :profile

    return unless user.admin?
    can :manage, :all
  end
end
