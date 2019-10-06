module Scraper
  module Actions
    class ParseMainPage
      # @param [Scraper::Browser] browser
      def initialize(browser)
        @browser = browser
      end

      def execute
        result = []

        begin
          result = execute!
        rescue Exception => e
          Rails.logger.error(e)
        ensure
          result
        end
      end

      def execute!
        links = try_parse_available_dates_with_food

        Rails.logger.debug("Found #{links.size} links")

        uris = links.map { |l| URI.join(browser.base_uri, l.attribute('href')) }

        uris.map { |uri| ParseMenu.new(browser, uri).execute }.compact
      end

      private

      attr_reader :browser

      def try_parse_available_dates_with_food
        header_links = browser.css('.cal__container a')

        header_links.reject { |link| link.attribute('class').include?('disabled') }
      end
    end
  end
end