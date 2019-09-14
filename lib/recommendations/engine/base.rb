module Recommendations
  module Engine
    class Base
      DEFAULT_LOCAL_TAX                 = 0.10_5 # This is about right for Crook County
      DEFAULT_NUMBER_OF_RECOMMENDATIONS = 5
      DEFAULT_KEYWORD_BLACKLIST         = %w(tortilla sauce extra).freeze

      def initialize(date, budget, opts = {})
        @date                      = date
        @budget                    = budget
        @number_of_recommendations = opts.fetch(:number_of_recommendations, DEFAULT_NUMBER_OF_RECOMMENDATIONS)
        @keyword_blacklist         = opts.fetch(:keyword_blacklist, DEFAULT_KEYWORD_BLACKLIST)
        @local_tax                 = opts.fetch(:local_tax, DEFAULT_LOCAL_TAX)
      end

      def generate
        raise NotImplementedError
      end

      private

      attr_reader :date, :budget, :number_of_recommendations, :keyword_blacklist, :local_tax

      def items
        @items ||= FoodItem
                     .below(budget_post_tax)
                     .offered(date)
      end

      def budget_post_tax
        budget * (1.0 - local_tax)
      end

      def try_finding_price_changes
        @price_changes ||= items.map do |item|
          if old_item = item.last_different_priced_item
            {
              restaurant: item.restaurant,
              name:       item.name,
              old_price:  old_item.price,
              new_price:  item.price,
            }
          end
        end.compact.group_by { |change| change[:restaurant] }
      end
    end
  end
end