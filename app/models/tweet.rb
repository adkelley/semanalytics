class Tweet < ActiveRecord::Base
  belongs_to :queries
  has_many :words
end
