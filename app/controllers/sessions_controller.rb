class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.confirm(user_params)
    if @user
      login(@user)
      #redirect_to "/"
      render "layouts/application"
    else
      redirect_to "/"
      flash[:error] = "Invalid email or password. Please try again."
    end
  end

  def signout
    logout
    redirect_to "/"
    flash[:success] = "Successfully logged out"
  end

  private
    def user_params
      @user_params = {}
      @user_params = params.require(:user).permit(:email, :password)
    end
end
