# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  root to: "dashboard#index"
  get "dashboard", to: "dashboard#index"
  get "organization", to: "organization#index"
  get "organization/csv", to: "organization#csv"
  get "calendar", to: "calendar#index"
  get "events", to: "events#index"
  resources :educations
  authenticate :user, ->(user) { user.admin? } do
    mount Motor::Admin => "/motor_admin"
    mount Sidekiq::Web => "/sidekiq"
  end
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  scope "(:locale)", locale: /en|ar/ do
    resources :holidays
    resources :educations
    resources :experiences
    resources :home, only: [:index]

    devise_for :users, skip: :omniauth_callbacks, path: "/auth", controllers: {
      registrations: "users/registrations"
    }
    delete "users", to: "devise/registrations#destroy", as: :destroy_user_registration

    resources :users do
      resources :assets
      resources :emergency_contacts
      resources :time_off_requests
      resources :user_requests
      patch "/user_requests/:id", to: "user_requests#update", as: "user_request_update"
      collection { post :import }
      get "settings", to: "settings#edit"
      patch "settings", to: "settings#update"
    end

    get "user_notifications", to: "user_notifications#index"
    get "user_notifications/notification_bell", to: "user_notifications#notification_bell"
  end
end
