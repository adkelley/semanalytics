class UsersController < ApplicationController
  def index
    @users = User.all
    render :index
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.create(user_params)
    login(@user)
    redirect_to "/users/#{@user.id}"  # <--- go to show
  end

  private
    def user_params
      @user_params = {}
      @user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
