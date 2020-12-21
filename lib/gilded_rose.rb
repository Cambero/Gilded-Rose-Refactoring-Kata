class GildedRose
  AGED_BRIE = 'Aged Brie'
  BACKSTAGE = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS = 'Sulfuras, Hand of Ragnaros'

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each(&method(:update))
  end

  private

  def update(item)
    case item.name
    when AGED_BRIE
      ItemAgedBrieUpdater.new(item).update
    when BACKSTAGE
      ItemBackstageUpdater.new(item).update
    when SULFURAS
      ItemSulfurasUpdater.new(item).update
    else
      ItemUpdater.new(item).update
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class ItemUpdater
  MAX_QUALITY_ALLOWED = 50
  MIN_QUALITY_ALLOWED = 0

  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    update_sell_in
    update_quality
    clamp_quality
  end

  private

  def update_sell_in
    item.sell_in -= 1
  end

  def update_quality
    item.quality += quality_delta
  end

  def clamp_quality
    item.quality = item.quality.clamp(MIN_QUALITY_ALLOWED, MAX_QUALITY_ALLOWED)
  end

  def quality_delta
    expired? ? -2 : -1
  end

  def expired?
    item.sell_in.negative?
  end
end

class ItemSulfurasUpdater < ItemUpdater
  def update; end
end

class ItemAgedBrieUpdater < ItemUpdater
  private

  def quality_delta
    expired? ? 2 : 1
  end
end

class ItemBackstageUpdater < ItemUpdater
  private

  def quality_delta
    return -item.quality if expired?
    return 3 if item.sell_in < 5
    return 2 if item.sell_in < 10

    1
  end
end

