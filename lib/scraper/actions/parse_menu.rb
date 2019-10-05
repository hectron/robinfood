require_relative '../menu'

module Scraper
  module Actions
    class ParseMenu
      def initialize(browser, uri)
        @browser = browser
        @uri     = uri
      end

      def execute
        result = nil

        begin
          result = execute!
        rescue Exception => e
          Rails.logger.error(e)
        ensure
          result
        end
      end

      def execute!
        date = try_parse_date

        if FoodItem.where(date_offered: date).exists?
          Rails.logger.info("Already got data for #{date}. Skipping")
          return
        end

        try_loading_uri

        items  = try_parsing_items(date)
        budget = try_parse_budget

        Rails.logger.debug("Found #{items.size} items for #{date}")

        Menu.new(date, budget, items)
      end

      private

      attr_reader :browser, :uri

      def try_loading_uri
        Rails.logger.debug("Navigating to #{uri}")

        browser.get(uri.to_s)
        browser.wait

        browser.at_css('.myfooda-event__restaurant').click
        browser.wait
      end

      def try_parsing_items(date)
        items = browser.css('.item')

        items.map { |item| FoodItem.from_element(item, date) }
      end

      def try_parse_budget
        div              = browser.at_css('.marketing__item')
        budget_as_string = div.text.split(' ').first

        budget_as_string.gsub!('$', '').to_f
      end

      def try_parse_date
        Rails.logger.debug('Parsing date')
        query_from_uri = Rack::Utils.parse_query(uri.query)
        query_from_uri['date']
      end
    end
  end
end
