class word < ActiveRecord::Base
	has_many :tweets
	belongs_to :group
end