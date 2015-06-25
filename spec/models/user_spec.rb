require 'rails_helper'

RSpec.describe User, :type => :model do
  before do
    user_params = Hash.new
    user_params[:email] = FFaker::Internet.email
    user_params[:password] = "blah"
    user_params[:password_confirmation] = user_params[:password]
    @current_user = User.create(user_params)
  end

  describe User do
    it "has a valid email address" do
      expect(@current_user.email).to_not be_nil
    end
    it "has a password digest" do
      expect(@current_user.password_digest).to_not be_nil
    end
  end
end
