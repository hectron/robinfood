module Scraper
  class FoodItem
    attr_reader :name, :price, :restaurant, :category, :url

    def initialize(name:, price:, restaurant:, category:, url:)
      @name       = name
      @price      = price
      @restaurant = restaurant
      @category   = category
      @url        = url
    end

    def self.from_element(element)
      restaurant = element['data-vendor_name'].gsub(/\W+$/, '')
      category   = element['data-category']
      name       = element.find_element(class: 'item__name').text.squish
      price      = element.find_element(class: 'item__price').text.gsub!('$', '').to_f
      url        = element.find_element(tag_name: 'a').attribute('href')

      new(name:       name,
          price:      price,
          restaurant: restaurant,
          category:   category,
          url:        url)
    end

    def under?(budget)
      price <= budget
    end

    def matches_blacklist?(blacklist)
      blacklist.any? do |descriptor|
        name.downcase.include?(descriptor)
      end
    end
  end
end