class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :username

  def self.from_hash(hash)
    if hash[:id].is_a? Fixnum
      instance = find hash[:id]
    else
      instance = self.new
    end

    hash.delete :id
    hash.delete :updated_at

    hash.each do |name, value|
      instance.send "#{name}=", value
    end

    instance
  end

end
