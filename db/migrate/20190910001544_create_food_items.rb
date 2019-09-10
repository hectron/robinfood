class CreateFoodItems < ActiveRecord::Migration[6.0]
  def change
    create_table :food_items do |t|
      t.string :name
      t.string :category
      t.string :restaurant
      t.string :url
      t.decimal :price
      t.date :date_offered

      t.timestamps
    end
  end
end
