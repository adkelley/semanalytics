class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.confirm(user_params)
    if @user
      login(@user)
      redirect_to "/users/#{@user.id}"
    else
      flash[:error] = "Sorry, invalid email or password"
      redirect_to "/"
    end
  end

  def signout
    logout
    redirect_to "/sign_in"
  end

  private
    def user_params
      @user_params = {}
      @user_params = params.require(:user).permit(:email, :password)
    end
end
