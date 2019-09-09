require_relative '../browser'
require_relative './login'
require_relative './parse_main_page'


module Scraper
  module Actions
    class Scrape
      def execute
        output = nil

        begin
          output = execute!
        rescue Exception => e
          Rails.logger.error(e)
        ensure
          output
        end
      end

      def execute!
        Login.new(browser).execute!
        ParseMainPage.new(browser).execute!
      end

      private

      def browser
        @browser ||= Browser.new
      end
    end
  end
end