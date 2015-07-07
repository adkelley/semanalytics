Rails.application.routes.draw do
  root to: "users#index"
  get "/users/", to: "user#index", as: "users" # perfunctory route
  get "/sign_up", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show", as: "profile"

  get "/sign_in", to: "sessions#new" # use /login
  post "/sessions", to: "sessions#create"
  
  # consider post "/logout", to: "sessions#logout"
  get "/sign_out", to: "sessions#signout" # Using a GET 
                                          #  to change state on the server
                                          #  is frowned upon
                                          #  someone could use CSRF
                                          #  attacks to logout users..

  get "/twitter", to: "twitter#data"
  get 'about/show' # remove route or refactor
end
