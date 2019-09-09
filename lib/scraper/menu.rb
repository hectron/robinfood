module Scraper
  class Menu
    attr_reader :date, :budget, :items

    def initialize(date = nil, budget = nil, items = [])
      @date   = date
      @budget = budget
      @items  = items
    end
  end
end