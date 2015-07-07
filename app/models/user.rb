class User < ActiveRecord::Base
  
  has_many :queries
  
  has_secure_password
  # should include more validation coverage
  # email, presence etc
  validates :email, uniqueness: true
  

  def self.confirm(params)
    user = User.find_by({email: params[:email]})
    user.try(:authenticate, params[:password])
  end
end
