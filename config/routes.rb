Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "session#new"
    post "/login", to: "session#create"
    delete "/logout", to: "session#destroy"
    post "/signup",  to: "users#create"
  end
  resources :password_resets, only: %i(new create edit update)
  resources :account_activations, only: %i(edit)
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
  resources :followers, only: %i(show)
  resources :followings, only: %i(show)
  resources :users, only: %i(index show create edit update destroy) do
    get "page/:page", action: :index, on: :collection
  end
 end
