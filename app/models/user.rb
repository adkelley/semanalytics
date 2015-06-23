class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: true
  has_many :querys

  def self.confirm(params)
    @user = User.find_by({email: params[:email]})
    @user.try(:authenticate, params[:password])
  end
end
