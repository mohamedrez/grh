# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  get "calendar", to: "calendar#index"
  get "organization", to: "organization#index"
  get "organization/csv", to: "organization#csv"
  get "events", to: "events#index"

  root to: "dashboard#index"

  authenticate :user, ->(user) { user.admin? } do
    mount Motor::Admin => "/motor_admin"
    mount Sidekiq::Web => "/sidekiq"
  end

  scope "(:locale)", locale: /en|fr/ do
    get "dashboard", to: "dashboard#index"

    resources :announcements
    resources :comments
    resources :holidays

    devise_for :users, path: "/auth"

    resources :users do
      resources :notes, except: %i[show]
      resources :assets
      resources :emergency_contacts
      resources :expenses
      patch "/expenses/:id/:status", to: "expenses#update_status", as: "update_status_expense"
      delete "/expenses/:id/receipts/:receipt_id", to: "expenses#delete_receipt", as: "delete_receipt_expense"
      resources :time_requests
      resources :user_requests
      patch "/user_requests/:id", to: "user_requests#update", as: "user_request_update"
      collection { post :import }
      get "settings", to: "settings#edit"
      patch "settings", to: "settings#update"
      resources :experiences, only: [:new, :create]
      resources :educations, only: [:new, :create]
    end

    get "user_notifications", to: "user_notifications#index"
    get "user_notifications/notification_bell", to: "user_notifications#notification_bell"
  end
end
