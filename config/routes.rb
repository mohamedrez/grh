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

    resources :roles
    resources :sites
    resources :announcements
    resources :comments
    resources :holidays
    resources :performance, only: :index
    resources :reviews
    resources :goals, except: :destroy
    get "/my_goals", to: "goals#my_goals", as: "my_goals"
    get "/team_manager_goals", to: "goals#team_manager_goals", as: "team_manager_goals"
    patch "/goals/:id/archive", to: "goals#archive", as: "archive_goal"
    patch "/goals/:id/end_goal", to: "goals#end_goal", as: "end_goal"
    get "objectives", to: "goals#objectives"

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
      resources :mission_orders
      patch "/mission_orders/:id/update_aasm_state", to: "mission_orders#update_aasm_state", as: "update_aasm_state_mission_order"
      get "/mission_orders/:id/payment", to: "mission_orders#new_payment", as: "new_payment_mission_order"
      patch "/mission_orders/:id/payment", to: "mission_orders#make_payment", as: "make_payment_mission_order"
    end

    get "user_notifications", to: "user_notifications#index"
    get "user_notifications/notification_bell", to: "user_notifications#notification_bell"
    resources :jobs
  end
end
