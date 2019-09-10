class ScrapeJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    require 'scaper/actions/scrape'

    action = Scraper::Actions::Scrape.new
    action.execute
  end
end