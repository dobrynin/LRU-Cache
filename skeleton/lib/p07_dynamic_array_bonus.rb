class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable

  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    return nil if i >= capacity || -i > @count
    if i >= 0
      @store[i]
    else
      @store[i % @count]
    end
  end

  def []=(i, val)
    return nil if -i > @count
    resize! while i >= capacity
    if i >= 0
      @store[i] = val
      @count = i + 1 if i > @count
    else
      @store[i % @count] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    each { |el| return true if el == val }
    false
  end

  def push(val)
    resize! if capacity == @count
    @store[@count] = val
    @count += 1
  end

  def unshift(val)
    resize! if capacity == @count
    @count.downto(1) do |i|
      @store[i] = @store[i - 1]
    end
    @count += 1
    @store[0] = val
  end

  def pop
    return nil if @count == 0
    val = @store[@count - 1]
    @store[@count - 1] = nil
    @count -= 1
    val
  end

  def shift
    return nil if @count == 0
    val = @store[0]
    1.upto(@count - 1) do |i|
      @store[i - 1] = @store[i]
    end
    @store[@count - 1] = nil
    @count -= 1
    val
  end

  def first
    @store[0]
  end

  def last
    @store[@count - 1]
  end

  def each
    @count.times do |i|
      yield(@store[i])
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless other.count == @count
    count.times do |i|
      return false unless self[i] == other[i]
    end

    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    old_capacity = capacity
    old_store = @store
    @store = StaticArray.new(capacity * 2)
    old_capacity.times do |i|
      @store[i] = old_store[i]
    end
  end
end
