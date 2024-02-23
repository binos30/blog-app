# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  devise_for :users, controllers: { sessions: "users/sessions" }

  authenticate :user, lambda { |u| u.decorate.administrator? } do
    mount MissionControl::Jobs::Engine, at: "/admin/jobs"
  end

  resources :posts, param: :slug do
    resources :feedbacks, only: :create
  end

  get "/users/posts", to: "posts#by_author"
end
