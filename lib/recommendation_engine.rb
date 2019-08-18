# Builds a list of recommended items
class RecommendationEngine
  attr_reader :budget, :items, :local_tax

  DEFAULT_LOCAL_TAX = 0.11 # This is about right for Crook county

  def initialize(parsed_page, local_tax = DEFAULT_LOCAL_TAX)
    @budget     = parsed_page[:budget]
    @items      = parsed_page[:items]
    @local_tax  = local_tax
  end

  def generate
    budget_remaining = recommended_budget.dup

    [].tap do |selected_items|
      while budget_remaining != 0 do
        available_items = items.select {|item| item.under?(budget_remaining) }

        if available_items.any?
          item = available_items.sample
          selected_items.push(item)
          budget_remaining -= item.price
        else
          budget_remaining = 0
        end
      end
    end
  end

  def recommended_budget
    budget.dup * (1 - local_tax)
  end
end
