Rails.application.routes.draw do
  get "registrations/new"
  get "registrations/create"
  root "words#home"

  get "quiz", to: "quiz#index"
  get "quiz/reset", to: "quiz#reset"
  post "quiz/record_answer", to: "words#record_answer"
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [:new, :create]
  resources :words
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "articles/:category_slug/:article_slug", to: "articles#show", as: :article
end
