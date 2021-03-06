class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  caches_page :twitter
  protect_from_forgery with: :exception
  layout "application"
  include SessionsHelper
  
end
