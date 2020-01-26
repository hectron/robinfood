namespace :food_items do
  desc 'Cleans up duplicate FoodItem entries based on name, restaurant and price'
  task clean: :environment do
    ids_to_delete = Doctor::Actions::FindStaleItems.call!

    Rails.logger.warn "Found #{ids_to_delete.size} ids to delete"

    batch_size = 500

    ids_to_delete.each_slice(batch_size).with_index do |ids, index|
      FoodItem.where(id: ids).destroy_all

      Rails.logger.warn "Deleted #{batch_size * (index + 1)} FoodItems"
    end
  end
end