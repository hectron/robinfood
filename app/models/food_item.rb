# frozen_string_literal: true

class FoodItem < ApplicationRecord
  scope :main_dishes, -> { where(category: MAIN_DISHES) }
  scope :side_dishes, -> { where(category: SIDE_DISHES) }
  scope :below, ->(budget) { where("price <= ?", budget) }
  scope :offered, ->(date) { where(date_offered: date) }

  ENTREE = "Entrees"
  SALAD = "Salads"
  SOUP = "Soups"
  SIDE = "Sides"
  BEVERAGE = "Beverages"
  DESSERT = "Desserts"

  MAIN_DISHES = [ENTREE, SALAD, SOUP].freeze
  SIDE_DISHES = [SIDE, BEVERAGE, DESSERT].freeze

  def self.from_element(element, date_offered)
    restaurant = element.attribute("data-vendor_name").gsub(/\W+$/, "")
    category = element.attribute("data-category")
    name = element.at_css(".item__name").text.squish
    price = element.at_css(".item__price").text.delete!("$").to_f
    url = element.at_css("a").attribute("href")
    dietary_restrictions = (element.attribute("data-dietary_restriction") || "").split(",")

    new.tap do |instance|
      instance.name = name
      instance.price = price
      instance.restaurant = restaurant
      instance.category = category
      instance.url = url
      instance.date_offered = date_offered
      instance.dietary_restrictions = dietary_restrictions
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
      .where("price <> ? AND date_offered < ?", price, date_offered)
      .order(date_offered: :desc)
      .first
  end
end
