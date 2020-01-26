module Structs
  module FoodItems
    class PriceDelta < Structs::Core
      attribute :item_name, Types::String
      attribute :restaurant, Types::String
      attribute :old_price, Types::Float
      attribute :new_price, Types::Float
      attribute :date, Types::Date
    end
  end
end