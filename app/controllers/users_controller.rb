class UsersController < ApplicationController
  def index
    render :index
  end

  def new
    @user = User.new
  end

  # def show
  #   @user = User.find(params[:id])
  # end

  def create
    @user = User.create(user_params)
    respond_to do |format|
      if @user.save
        login(@user)
        format.html { redirect_to "/", notice: 'User was successsfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to "/" }
        if User.find_by_email(user_params[:email])
          flash[:error] = "This account already exists, please sign in instead"
        else
          flash[:error] = "Invalid, email address or password.  Please try again"
        end
      end
    end
  end

  private
    def user_params
      @user_params = {}
      @user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
