require_relative './parse_menu'

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
        urls = links.map { |l| l['href'] }

        urls.map { |url| ParseMenu.new(browser, url).execute }.compact
      end

      private

      attr_reader :browser

      def try_parse_available_dates_with_food
        header_links = browser.find_elements(css: '.cal__container a')

        header_links.reject { |link| link['class'].include?('disabled') }
      end
    end
  end
end