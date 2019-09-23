require 'forwardable'

module Scraper
  class Browser
    extend Forwardable

    def_delegator :client, :goto, :get
    def_delegators :client, :at_css, :css, :at_xpath, :xpath, :screenshot, :current_url

    DEFAULT_TIMEOUT = 10 # seconds

    def initialize(opts = {})
      @client  = Ferrum::Browser.new(browser_options: { 'no-sandbox' => nil })
      @timeout = opts.fetch(:timeout, DEFAULT_TIMEOUT)
      @options = opts
    end

    def with_wait
      result = yield

      # Wait for the page to load
      timeout.times do
        if client.network.status == 200
          break
        end

        sleep(1)
      end

      result
    end

    private

    attr_reader :client, :timeout, :options
  end
end