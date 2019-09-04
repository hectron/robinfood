require 'selenium-webdriver'
require_relative './lib/fooda_page'
require_relative './lib/recommendation_engine'
require_relative './lib/slack_adapter'

class Application
  DEFAULT_TIMEOUT           = 10 # seconds
  NUMBER_OF_RECOMMENDATIONS = 5
  FOODA_USERNAME            = ENV.fetch('FOODA_USERNAME').freeze
  FOODA_PASSWORD            = ENV.fetch('FOODA_PASSWORD').freeze
  CHANNELS_TO_POST_TO       = ENV.fetch('SLACK_CHANNELS_TO_POST_TO', '#accountability-stand').freeze

  class << self
    def run
      begin
        log_into_fooda
        list_all_items

        page_information = parse_page
        build_recommendations_and_notify(page_information)
      ensure
        driver.quit
      end
    end

    private

    def log_into_fooda
      puts "Logging into Fooda"

      driver.get('https://app.fooda.com/login')

      driver.find_element(id: 'user_email').send_keys(FOODA_USERNAME)
      driver.find_element(id: 'user_password').send_keys(FOODA_PASSWORD)
      driver.find_element(name: 'commit', type: 'submit').click

      wait.until { driver.find_element(class: 'myfooda-event__product').displayed? }

      puts "Successfully logged in!"
    end

    def list_all_items
      puts "Finding all restaurants"

      # Find the first restaurant to have this class, which is the all restaurants
      driver.find_element(class: 'myfooda-event__restaurant').click

      wait.until { driver.find_element(class: 'marketing__item').displayed? }

      puts "All items loaded!"
    end

    def parse_page
      puts "Parsing available items"

      FoodaPage.new(driver).parse.tap do |results|
        puts "Found #{results[:items].size} items available"
      end
    end

    def build_recommendations_and_notify(page_information)
      engine                   = RecommendationEngine.new(page_information)
      lists_of_recommendations = NUMBER_OF_RECOMMENDATIONS.times.map { engine.generate }
      recommendations          = { date: page_information[:date], budget: engine.budget, recommendations: lists_of_recommendations }

      SlackAdapter.announce(recommendations, channel: CHANNELS_TO_POST_TO)
    end

    def driver
      @driver ||= Selenium::WebDriver.for(:chrome, options: options)
    end

    def options
      Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'no-sandbox', 'disable-gpu'])
    end

    def wait
      Selenium::WebDriver::Wait.new(timeout: DEFAULT_TIMEOUT)
    end
  end
end

Application.run
