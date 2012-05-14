class Post < ActiveRecord::Base

  include Skeleton

  attr_accessible :user_id, :content

  belongs_to :user

end