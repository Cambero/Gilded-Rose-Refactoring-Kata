class GildedRose
  AGED_BRIE = 'Aged Brie'
  BACKSTAGE = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS = 'Sulfuras, Hand of Ragnaros'

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name == SULFURAS

      decrease_sell_in(item)
      expired = item.sell_in.negative?

      case item.name
      when AGED_BRIE
        update_item_quality(item, 1)
        update_item_quality(item, 1) if expired
      when BACKSTAGE
        update_item_quality(item, 1)
        update_item_quality(item, 1) if item.sell_in < 10
        update_item_quality(item, 1) if item.sell_in < 5
        update_item_quality(item, -item.quality) if expired
      else
        update_item_quality(item, -1)
        update_item_quality(item, -1) if expired
      end
    end
  end

  private

  def update_item_quality(item, quantity)
    item.quality = (item.quality + quantity).clamp(0, 50)
  end

  def decrease_sell_in(item)
    item.sell_in = item.sell_in - 1
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
