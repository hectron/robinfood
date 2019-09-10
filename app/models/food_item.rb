class FoodItem < ApplicationRecord
  scope :below, -> (budget) { where('price <= ?', budget) }

  def self.from_element(element, date_offered)
    restaurant = element['data-vendor_name'].gsub(/\W+$/, '')
    category   = element['data-category']
    name       = element.find_element(class: 'item__name').text.squish
    price      = element.find_element(class: 'item__price').text.gsub!('$', '').to_f
    url        = element.find_element(tag_name: 'a').attribute('href')

    new.tap do |instance|
      instance.name         = name
      instance.price        = price
      instance.restaurant   = restaurant
      instance.category     = category
      instance.url          = url
      instance.date_offered = date_offered
    end
  end

  def under?(budget)
    price < budget
  end

  def last_different_priced_item
    FoodItem
      .where(name: name, restaurant: restaurant)
      .where('price <> ? AND date_offered < ?', price, date_offered)
      .order(date_offered: :desc)
  end
end
