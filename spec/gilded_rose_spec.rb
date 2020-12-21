require_relative '../lib/gilded_rose'

describe GildedRose do
  describe '#update_quality' do
    it 'At the end of each day our system lowers sell_in and quality values for every item ' do
      item = Item.new('+5 Dexterity Vest', 10, 20)
      GildedRose.new([item]).update_quality

      expect(item.sell_in).to eq(9)
      expect(item.quality).to eq(19)
    end

    it 'Once the sell by date has passed, Quality degrades twice as fast' do
      item = Item.new('+5 Dexterity Vest', 1, 11)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(0)
      expect(item.quality).to eq(10)

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-1)
      expect(item.quality).to eq(8)
    end

    it 'The Quality of an item is never negative' do
      item = Item.new('Elixir of the Mongoose', 1, 0)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(0)
      expect(item.quality).to eq(0)

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-1)
      expect(item.quality).to eq(0)
    end

    it '"Aged Brie" actually increases in Quality the older it gets' do
      item = Item.new('Aged Brie', 1, 2)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(0)
      expect(item.quality).to eq(3)

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-1)
      expect(item.quality).to eq(5)
    end

    it 'The Quality of an item is never more than 50' do
      item = Item.new('Aged Brie', 1, 50)
      item2 = Item.new('Backstage passes to a TAFKAL80ETC concert', 4, 50)
      gilded_rose = GildedRose.new([item, item2])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(0)
      expect(item.quality).to eq(50)

      expect(item2.sell_in).to eq(3)
      expect(item2.quality).to eq(50)
    end

    it '"Sulfuras", being a legendary item, never has to be sold or decreases in Quality' do
      item = Item.new('Sulfuras, Hand of Ragnaros', 1, 80)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(1)
      expect(item.quality).to eq(80)
    end

    it '"Backstage passes", Quality increases by 2 when there are 10 days or less' \
       'and by 3 when there are 5 days or less but Quality drops to 0 after the concert' do
      item = Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 1)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(10)
      expect(item.quality).to eq(2)

      (1..5).each do |i|
        gilded_rose.update_quality
        expect(item.sell_in).to eq(10 - i)
        expect(item.quality).to eq(2 + i * 2)
      end

      (1..5).each do |i|
        gilded_rose.update_quality
        expect(item.sell_in).to eq(5 - i)
        expect(item.quality).to eq(12 + i * 3)
      end

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-1)
      expect(item.quality).to eq(0)

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-2)
      expect(item.quality).to eq(0)
    end

    it '"Conjured" items degrade in Quality twice as fast as normal items' do
      item = Item.new('Conjured Mana Cake', 1, 7)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality
      expect(item.sell_in).to eq(0)
      expect(item.quality).to eq(5)

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-1)
      expect(item.quality).to eq(1)

      gilded_rose.update_quality
      expect(item.sell_in).to eq(-2)
      expect(item.quality).to eq(0)
    end
  end
end
