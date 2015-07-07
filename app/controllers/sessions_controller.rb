class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.confirm(user_params)
    if @user
      login(@user)
      redirect_to "/"
    else
      redirect_to "/" # redirect to an actual login page
      flash[:error] = "Invalid email or password. Please try again."
    end
  end

  def signout # refactor action name
    logout
    redirect_to "/"
    flash[:success] = "Successfully logged out"
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
