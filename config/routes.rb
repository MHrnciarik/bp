Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "daily_missions", to: "daily_missions#index"
  post "daily_missions/:period/:mission_key/claim", to: "daily_missions#claim", as: :claim_mission
  post "login_streak_rewards/:day/claim", to: "login_streak_rewards#create", as: :claim_login_streak_reward
  get "leaderboard", to: "leaderboards#index"


  resources :invoices
  resources :expenses
  resources :clients
  resources :vendors
  resources :achievements, only: [ :index ]
  resources :profiles, only: [ :index ]
  resources :companies, only: [ :new, :create, :destroy ] do
    patch :select, on: :member
  end

  root "profiles#index"
end
