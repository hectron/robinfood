require 'forwardable'

module Scraper
  class Browser
    extend Forwardable

    def_delegators :driver, :get, :find_element, :find_elements, :execute_script

    DEFAULT_TIMEOUT = 10 # seconds

    def initialize(opts = {})
      @options = Selenium::WebDriver::Chrome::Options.new(args: %w(headless no-sandbox disable-gpu))
      @driver  = Selenium::WebDriver.for(:chrome, options: options)
      @timeout = opts.fetch(:timeout, DEFAULT_TIMEOUT)
    end

    def wait
      Selenium::WebDriver::Wait.new(timeout: timeout)
    end

    private

    attr_reader :driver, :options, :timeout
  end
end