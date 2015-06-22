Rails.application.routes.draw do
  root to: "users#index"
  get "/d3", to: "welcome#index"
  get "/users/", to: "user#index", as: "users"
  get "/users/new", to: "users#new", as: "new_user"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"

  get "/sign_in", to: "sessions#new"
  post "/sessions", to: "sessions#create"
end
