Rails.application.routes.draw do
  root to: "users#index"
<<<<<<< HEAD
  get "/d3", to: "welcome#index"
  get "/json", to: "welcome#data"
=======
  #get "/d3", to: "welcome#index"
>>>>>>> sidebar
  get "/users/", to: "user#index", as: "users"
  get "sign_up", to: "users#new"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"

  get "/sign_in", to: "sessions#new"
  post "/sessions", to: "sessions#create"
  get "/sign_out", to: "sessions#signout"

<<<<<<< HEAD
  get "/search/:query", to: "twitter#search"
=======
  get 'about/show'
>>>>>>> sidebar
end
