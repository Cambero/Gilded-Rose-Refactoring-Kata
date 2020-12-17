#!/usr/bin/env ruby

require_relative '../lib/gilded_rose'

items = [
  Item.new('+5 Dexterity Vest', 10, 20),
  Item.new('Aged Brie', 2, 0),
  Item.new('Elixir of the Mongoose', 5, 7),
  Item.new('Sulfuras, Hand of Ragnaros', 0, 80),
  Item.new('Sulfuras, Hand of Ragnaros', -1, 80),
  Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20),
  Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 49),
  Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 49),
  # This Conjured item does not work properly yet
  Item.new('Conjured Mana Cake', 3, 6) # <-- :O
]

days = 100
gilded_rose = GildedRose.new items

puts '=== Manual TextTest ==='

File.open('spec/texttest_run.txt', 'w') do |f|
  f.puts 'OMGHAI!'
  (0..days).each do |day|
    f.puts "-------- day #{day} --------"
    f.puts 'name, sellIn, quality'
    items.each do |item|
      f.puts item
    end
    f.puts ''
    gilded_rose.update_quality
  end
end
