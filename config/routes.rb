Rails.application.routes.draw do
  root to: "users#index"
  get "/users/", to: "user#index", as: "users"
  get "sign_up", to: "users#new"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"

  get "/sign_in", to: "sessions#new"
  post "/sessions", to: "sessions#create"
  get "/sign_out", to: "sessions#signout"

  get "/twitter", to: "twitter#data"
  post "/twitter", to: "twitter#threshold"
  get 'about/show'
end
