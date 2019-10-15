class AddDietaryRestrictionsToFoodItem < ActiveRecord::Migration[6.0]
  def change
    add_column :food_items, :dietary_restrictions, :string, array: true, default: []
  end
end
