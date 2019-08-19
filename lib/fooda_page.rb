require_relative './fooda_item'

# Parses the all items page, and generates what the budget is for the day
# as well as what items are available to purchase
class FoodaPage
  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def parse
    budget = parse_budget
    items  = parse_items
    date   = parse_date

    {
      date:   date,
      budget: budget,
      items:  items
    }
  end

  private

  def parse_budget
    div              = driver.find_element(class: 'marketing__item')
    budget_as_string = div.text.split(' ').first

    budget_as_string.gsub!('$', '').to_f
  end

  def parse_items
    items = driver.find_elements(class: 'item')

    items.map { |item| FoodaItem.from_element(item) }
  end

  def parse_date
    # For some reason, the following doesn't work, so we call out to JS to get
    # it
    # text = driver.find_element(class: 'secondary-bar__label').text
    # text.gsub('delivery ', '')
    js   = "return document.getElementsByClassName('secondary-bar__label')[0].innerHTML"
    text = driver.execute_script(js)
    text.split(',').last
  end
end
