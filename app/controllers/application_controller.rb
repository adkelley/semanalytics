class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  caches_page :twitter # No action called :twitter in this controller
                       # No action called :twitter found in any controller
                       # Remove this and caching gem into a feature branch
  protect_from_forgery with: :exception
  layout "application" # why specify? Remove this line
  include SessionsHelper 
  
end
