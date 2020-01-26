module Recommendations
  module Engine
    class Base
      DEFAULT_LOCAL_TAX                 = 0.10_5 # This is about right for Crook County
      DEFAULT_NUMBER_OF_RECOMMENDATIONS = 5
      DEFAULT_KEYWORD_BLACKLIST         = %w(tortilla sauce extra).freeze

      def initialize(date, budget, recommendation_count: nil, local_tax: nil, keyword_blacklist: nil)
        @date                 = date
        @budget               = budget
        @recommendation_count = recommendation_count || DEFAULT_NUMBER_OF_RECOMMENDATIONS
        @local_tax            = local_tax || DEFAULT_LOCAL_TAX
        @keyword_blacklist    = keyword_blacklist || DEFAULT_KEYWORD_BLACKLIST
      end

      def generate
        if template_data.present?
          Recommendations::Decision.new(date, budget, template_path, template_data)
        end
      end

      private

      attr_reader :date, :budget, :number_of_recommendations, :keyword_blacklist, :local_tax

      def template_data
        raise NotImplementedError
      end

      def template_path
        raise NotImplementedError
      end

      # @return [Array<FoodItem>]
      def items_available
        raise NotImplementedError
      end

      def budget_post_tax
        budget * (1.0 - local_tax)
      end

      def try_finding_price_changes
        @price_changes ||= items_available
                             .map(&:last_price_delta)
                             .compact
                             .group_by(&:restaurant)
      end
    end
  end
end