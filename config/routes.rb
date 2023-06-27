# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  default_url_options host: "uat.humaneo.ma", port: 8800
  get "calendar", to: "calendar#index"
  get "organization", to: "organization#index"
  get "organization/csv", to: "organization#csv"
  get "events", to: "events#index"

  root to: "dashboard#index"

  authenticate :user, ->(user) { user.admin? } do
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
    patch "/goals/:id/archive", to: "goals#archive", as: "archive_goal"
    patch "/goals/:id/end_goal", to: "goals#end_goal", as: "end_goal"
    get "objectives", to: "goals#objectives"
    resources :user_requests, only: [:index]
    resources :expenses, only: [:index]
    resources :time_requests, only: [:index]
    resources :mission_orders, only: [:index]

    scope :team, as: "team" do
      resources :users, only: [:index]
      resources :goals, only: [:index]
      resources :user_requests, only: [:index]
      resources :expenses, only: [:index]
      resources :time_requests, only: [:index]
      resources :mission_orders, only: [:index]
    end

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
      resources :goals, only: [:index]
    end

    get "user_notifications", to: "user_notifications#index"
    get "user_notifications/notification_bell", to: "user_notifications#notification_bell"
    resources :jobs do
      resources :job_applications
    end
    resources :job_applications do
      delete :delete_resume, on: :member
    end
    get "/job_applications/:id/infos", to: "job_applications#infos", as: "job_application_infos"
    patch "/job_applications/:id/update_aasm_state", to: "job_applications#update_aasm_state", as: "update_aasm_state_job_application"
  end
end
