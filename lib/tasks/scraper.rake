namespace :scraper do
  desc 'Scrapes Fooda Items'
  task :run => :environment do
    row_limit          = 10_000
    current_item_count = FoodItem.count

    Rails.logger.info "There are currently #{current_item_count} items in the database"

    if current_item_count < row_limit
      Scraper::Actions::Scrape.execute
    else
      Rails.logger.error "We ran out of rows in the database for Heroku Postgres Free Tier."
    end
  end
end