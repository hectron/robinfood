class ScrapeJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Scraper::Actions::Scrape.new.execute
  end
end