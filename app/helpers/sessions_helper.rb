module SessionsHelper

  def login(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
   @current_user != nil
  end

  def require_login
    if current_user == nil
<<<<<<< HEAD
      # redirect_to sign_in_path
    end
=======
      redirect_to "/sign_up"
     end
>>>>>>> 3b82a504ddb0909adf1760fd9a8c93bbdbe62291
  end

  def logout
    @current_user = session[:user_id] = nil
  end

end
