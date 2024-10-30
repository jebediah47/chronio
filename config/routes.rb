Rails.application.routes.draw do
  scope "(:locale)", locale: /en|es|gr|fr/ do  # Add any additional supported language codes here
    resources :posts do
      scope module: :posts do
        resources :reactions, only: [ :create ]
        resources :comments, only: [:new, :create, :index]
      end
    end

    resources :feeds, only: [:show]

    devise_for :users
    get "pages/home", to: "pages#home", as: :pages_home
    get "pages/about", to: "pages#about", as: :pages_about
    get "pages/tos", to: "pages#tos", as: :pages_tos
    get "pages/privacy-policy", to: "pages#privacy_policy", as: :pages_privacy_policy
    get "pages/network", to: "pages#network", as: :network
    get "pages/jobs", to: "pages#jobs", as: :jobs
    get "pages/messages", to: "pages#messages", as: :messages

    # Health check route
    get "up" => "rails/health#show", as: :rails_health_check

    # PWA dynamic routes
    get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
    get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

    authenticated :user do
      root to: "feed#show", as: :authenticated_user_root
    end

    # Root path route ("/")
    root "pages#home"
  end
end
