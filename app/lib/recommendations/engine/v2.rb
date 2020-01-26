require 'erb'

# This engine generates recommendations by:
#
#   - preferring main dishes, ad then side items to fill in the budget.
#   - notifies about any price changes
module Recommendations
  module Engine
    class V2 < Base
      private

      def template_data
        most_expensive_items = try_finding_most_expensive_items
        recommendations      = try_finding_recommendations
        price_changes        = try_finding_price_changes

        {}.tap do |data|
          data[:most_expensive_items] = most_expensive_items.present? ? most_expensive_items : nil
          data[:recommendations]      = recommendations.flatten.present? ? recommendations : nil
          data[:price_changes]        = price_changes.present? ? price_changes : nil
        end
      end

      def template_path
        File.join(File.expand_path(File.dirname(__FILE__)), '..', 'presentation', 'v2.md.erb').freeze
      end

      def try_finding_most_expensive_items
        sorted_items = items.sort_by(&:price).dup.reject { |i| i.matches_blacklist?(keyword_blacklist) }

        number_of_recommendations.times.map { |_| sorted_items.pop }.compact
      end

      def try_finding_recommendations
        # Dedup
        number_of_recommendations.times.map do |_|
          budget_remaining = budget_post_tax
          selected_items   = items.dup.to_a

          [].tap do |recommendations|
            while budget_remaining != 0
              available_items = selected_items.select { |i| i.under?(budget_remaining) && !i.matches_blacklist?(keyword_blacklist) }

              if available_items.any?
                main_items = available_items.select(&:main_dish?)
                side_items = available_items.select(&:side_dish?)

                item = main_items.any? ? main_items.sample : side_items.sample

                if item
                  selected_items.delete_at(selected_items.index(item))
                  recommendations.push(item)
                  budget_remaining -= item.price
                else
                  budget_remaining = 0
                end
              else
                budget_remaining = 0
              end
            end
          end
        end.uniq
      end

      def items_available
        @items_available ||= FoodItem.below(budget_post_tax).offered(date)
      end
    end
  end
end