Rails.application.routes.draw do
  # 1. 静的ページ・お問い合わせ（優先度高め）
  get "terms", to: "static_pages#terms", as: :terms
  get "privacy", to: "static_pages#privacy", as: :privacy
  get "contact", to: "inquiries#new", as: :contact
  resources :inquiries, only: [:create] # 送信用のアクションのみ追加

  root "words#home"

  # 2. クイズ・ゲストログイン
  get "quiz", to: "quiz#index"
  get "quiz/reset", to: "quiz#reset"
  post "quiz/record_answer", to: "quiz#record_answer"
  post "guest_login", to: "sessions#guest_login", as: :guest_login

  # 3. 認証・ユーザー登録
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [:new, :create]

  # 4. メイン機能
  resources :words

  # 5. その他
  get "up" => "rails/health#show", as: :rails_health_check
end