# This action logs into the website and lands on the main welcome page
module Scraper
  module Actions
    class Login
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
        browser.get('https://app.fooda.com/login')

        try_login

        true
      end

      private

      attr_reader :browser, :username, :password

      def try_login
        browser.find_element(id: 'user_email').send_keys(username)
        browser.find_element(id: 'user_password').send_keys(password)
        browser.find_element(name: 'commit', type: 'submit').click

        browser.wait.until { browser.find_element(class: 'myfooda-event__product').displayed? }
      end

    end
  end
end