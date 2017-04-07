class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    acc = 0
    each_with_index do |el, i|
      acc += el ^ i
    end

    acc
  end
end

class String
  def hash
    chars.map(&:ord).hash
  end

end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    (keys.map(&:to_s).map(&:hash).sort + values.map(&:hash).sort).hash
  end
end
