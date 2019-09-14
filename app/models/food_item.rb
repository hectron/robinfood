class FoodItem < ApplicationRecord
  scope :main_dishes, -> { where(category: MAIN_DISHES) }
  scope :side_dishes, -> { where(category: SIDE_DISHES) }
  scope :below, -> (budget) { where('price <= ?', budget) }
  scope :offered, -> (date) { where(date_offered: date) }

  ENTREE   = 'Entrees'.freeze
  SALAD    = 'Salads'.freeze
  SOUP     = 'Soups'.freeze
  SIDE     = 'Sides'.freeze
  BEVERAGE = 'Beverages'.freeze
  DESSERT  = 'Desserts'.freeze

  MAIN_DISHES = [ENTREE, SALAD, SOUP]
  SIDE_DISHES = [SIDE, BEVERAGE, DESSERT]

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

  def main_dish?
    MAIN_DISHES.include?(category)
  end

  def side_dish?
    SIDE_DISHES.include?(category)
  end

  def under?(budget)
    price < budget
  end

  def matches_blacklist?(blacklist)
    blacklist.any? do |descriptor|
      name.downcase.include?(descriptor)
    end
  end

  def last_different_priced_item
    FoodItem
      .where(name: name, restaurant: restaurant)
      .where('price <> ? AND date_offered < ?', price, date_offered)
      .order(date_offered: :desc)
      .first
  end
end
