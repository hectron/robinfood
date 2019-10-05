# This action logs into the website and lands on the main welcome page
module Scraper
  module Actions
    class Login
      LOGIN_URL = 'https://app.fooda.com/login'.freeze

      # @param [Scraper::Browser] browser
      # @param [String] username
      # @param [String] password
      def initialize(browser, username = ENV['FOODA_USERNAME'], password = ENV['FOODA_PASSWORD'])
        @browser  = browser
        @username = username
        @password = password
      end

      def execute
        result = false

        begin
          result = execute!
        rescue Exception => e
          Rails.logger.error(e)
        ensure
          result
        end
      end

      def execute!
        try_login

        true
      end

      private

      attr_reader :browser, :username, :password

      def try_login
        browser.get(LOGIN_URL)
        browser.wait

        browser.at_css('#user_email').focus.type(username)
        browser.at_css('#user_password').focus.type(password, :Enter)
        browser.wait

        Rails.logger.debug('Logged in!')

        browser.current_url != LOGIN_URL
      end
    end
  end
end