class Query < ActiveRecord::Base
  validates :user_id, presence: true
  
  has_many :tweets
  belongs_to :user
end
