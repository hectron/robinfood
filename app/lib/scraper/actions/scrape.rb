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
        Login.new(browser).execute
        menus = ParseMainPage.new(browser).execute

        menus.each do |menu|
          ApplicationRecord.transaction do
            menu.items.each(&:save!)
          end
        end
      end

      private

      def browser
        @browser ||= Browser.new
      end
    end
  end
end