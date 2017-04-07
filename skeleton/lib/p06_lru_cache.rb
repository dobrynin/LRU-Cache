require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      link = @map[key]
      update_link!(link)
      link.val
    else
      calc!(key)
      @store.last.val
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    eject! if @map.count == @max

    link = Link.new(key, @prc.call(key))
    @map.set(key, link)
    @store.append(key, link.val)
  end

  def update_link!(link)
    @store.remove(link.key)
    @store.append(link.key, link.val)
    @map[link.key] = @store.last
  end

  def eject!
    @map.delete(@store.first.key)
    @store.remove(@store.first.key)
  end
end
