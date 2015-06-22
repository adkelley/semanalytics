Rails.application.routes.draw do
<<<<<<< HEAD
  root to: 'welcome#index'
=======
  root to: "users#index"
  get "/users/", to: "user#index", as: "users"
  get "/users/new", to: "users#new", as: "new_user"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"

  get "/sign_in", to: "sessions#new"
  post "/sessions", to: "sessions#create"
>>>>>>> f6a8511b3ad469487331beef0cf070b5d3fc8df9
end
