class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    @next.prev = @prev
    @prev.next = @next
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head, @tail = Link.new, Link.new
    @head.next, @tail.prev = @tail, @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    include?(key) ? get_link(key).val : nil
  end

  def get_link(key)
    each { |link| return link if link.key == key }
    nil
  end

  def include?(key)
    each { |link| return true if link.key == key }

    false
  end

  def append(key, val)
    remove(key) if include?(key)
    link = Link.new(key, val)

    link.prev, link.next = @tail.prev, @tail

    @tail.prev, link.prev.next = link, link
  end


  def update(key, val)
    get_link(key).val = val if include?(key)
  end

  def remove(key)
    get_link(key).remove
  end

  def each
    link = first
    until link == @tail
      yield(link)
      link = link.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
