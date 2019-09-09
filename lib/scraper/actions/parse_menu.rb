require_relative '../food_item'
require_relative '../menu'

module Scraper
  module Actions
    class ParseMenu
      def initialize(browser, url)
        @browser = browser
        @url     = url
      end

      def execute
        result = Menu.new

        begin
          result = execute!
        rescue Exception => e
          Rails.logger.error(e)
        ensure
          result
        end
      end

      def execute!
        puts "Navigating to #{url}"
        browser.get(url)

        require 'pry'
        browser.find_element(class: 'myfooda-event__restaurant').click
        browser.wait.until { browser.find_element(class: 'marketing__item').displayed? }

        items  = try_parsing_items
        date   = try_parse_date
        budget = try_parse_budget

        puts "Found #{items.size} items for #{date}"

        Menu.new(date, budget, items)
      end

      private

      attr_reader :browser, :url

      def try_parsing_items
        items = browser.find_elements(class: 'item')

        items.map { |item| FoodItem.from_element(item) }
      end

      def try_parse_budget
        div              = browser.find_element(class: 'marketing__item')
        budget_as_string = div.text.split(' ').first

        budget_as_string.gsub!('$', '').to_f
      end

      def try_parse_date
        query_from_url = Rack::Utils.parse_query(URI.parse(url).query)
        query_from_url['date']
      end
    end
  end
end