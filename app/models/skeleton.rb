module Skeleton

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods

    def from_hash(hash)
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

  def to_hash
    attributes
  end

  def remote
    nil
  end

end