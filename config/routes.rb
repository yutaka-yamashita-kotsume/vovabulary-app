Rails.application.routes.draw do
  get "inquiries/new"
  get "inquiries/create"
  get "terms", to: "static_pages#terms", as: :terms     # as: :terms を追加
  get "privacy", to: "static_pages#privacy", as: :privacy # as: :privacy を追加
  
  root "words#home"

  get "static_pages/terms"
  get "static_pages/privacy"
  get "registrations/new"
  get "registrations/create"

  # クイズ関連
  get "quiz", to: "quiz#index"
  get "quiz/reset", to: "quiz#reset"
  post "quiz/record_answer", to: "quiz#record_answer"

  # ゲストログイン用のルートを追加
  post "guest_login", to: "sessions#guest_login", as: :guest_login

  # 認証・登録
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [:new, :create]
  get "contact", to: "inquiries#new", as: :contact # URLを /contact にする

  # 単語帳
  resources :words
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "articles/:category_slug/:article_slug", to: "articles#show", as: :article
end
