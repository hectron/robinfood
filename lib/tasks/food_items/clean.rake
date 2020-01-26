namespace :food_items do
  desc 'Cleans up duplicate FoodItem entries based on name, restaurant and price'
  task clean: :environment do
    ids_to_delete = Doctor::Actions::FindStaleFoodItemIds.call!

    Rails.logger.warn "Found #{ids_to_delete.size} ids to delete"

    batch_size    = 500
    items_deleted = 0

    ids_to_delete.each_slice(batch_size) do |ids|
      FoodItem.where(id: ids).destroy_all

      items_deleted += ids.size

      Rails.logger.warn "Deleted #{items_deleted} out of #{ids_to_delete.size} stale FoodItems"
    end
  end
end