class User < ActiveRecord::Base

  include Skeleton

  attr_accessible :first_name, :last_name, :username

  has_many :posts

end
