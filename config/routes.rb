# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  root to: "dashboard#index"
  get "dashboard", to: "dashboard#index"

  resources :educations
  authenticate :user, ->(user) { user.admin? } do
    mount Motor::Admin => "/motor_admin"
    mount Sidekiq::Web => "/sidekiq"
  end
  devise_for :users, skip: :omniauth_callbacks, path: "/auth"
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  scope "(:locale)", locale: /en|ar/ do
    resources :educationsr
    resources :experiences
    resources :home, only: [:index]

    devise_for :users, skip: :omniauth_callbacks, path: "/auth", controllers: {
      registrations: "users/registrations"
    }
    delete "users", to: "devise/registrations#destroy", as: :destroy_user_registration
    get "users/profile/edit", to: "profiles#edit"
    patch "users/profile", to: "profiles#update"

    resources :users, only: [:index, :show, :edit, :update] do
      resources :time_off_requests
    end

    resources :tracks, only: [:index]
    resources :courses, only: [:index, :show] do
      resources :steps, only: [:index, :show]
    end
    post "/user_quiz_responses", to: "user_quiz_responses#create"
    resources :user_progresses, only: [:update]
    resources :user_progresses, only: [:create, :update]
    get "user_notifications", to: "user_notifications#index"
    get "user_notifications/notification_bell", to: "user_notifications#notification_bell"
  end
end
