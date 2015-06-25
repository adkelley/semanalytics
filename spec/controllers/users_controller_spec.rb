require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  # before do
  #   user_params = Hash.new
  #   user_params[:email] = FFaker::Internet.email
  #   user_params[:password] = "blah"
  #   user_params[:password_confirmation] = user_params[:password]
  #   @user = User.create(user_params)
  #   allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  # end

  describe "Get #index" do
    it "should render the :index view" do 
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "Post #create" do
    it "should redirect_to '/' when create succeeds" do
      post :create, user: {email: "test@blah.com", password: "blah", password_confirmation: "blah"}
      expect(response.status).to be(302)
      expect(response.location).to match(/\//)
    end
    
    it "should redirect_to '/' when create doesn't succeed" do
      post :create, user: {email: "testblah.com", password: "blah", password_confirmation: "blah"}
      expect(response.status).to be(302)
      expect(response.location).to match(/\//)
    end
  end
end




