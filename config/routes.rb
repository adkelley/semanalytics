Rails.application.routes.draw do
  get 'about/show'

  root to: "users#index"
  get "/d3", to: "welcome#index"
  get "/users/", to: "user#index", as: "users"
  get "sign_up", to: "users#new"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"

  get "/sign_in", to: "sessions#new"
  post "/sessions", to: "sessions#create"
  get "/sign_out", to: "sessions#signout"
end
