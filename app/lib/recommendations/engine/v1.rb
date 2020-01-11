require 'erb'
# This engine generates recommendations by:
#
#   - picking out random main dishes under the budget
#   - picking out random side dishes under the budget
#   - notifies about any price changes
module Recommendations
  module Engines
    class V1 < Base
      private

      def template_data
        main_dishes   = try_finding_main_dishes
        side_dishes   = try_finding_side_dishes
        price_changes = try_finding_price_changes

        {
          main_dishes:   main_dishes,
          side_dishes:   side_dishes,
          price_changes: price_changes,
        }
      end

      def template_path
        File.join(File.expand_path(File.dirname(__FILE__)), '..', 'presentation', 'v1.md.erb')
      end

      def try_finding_main_dishes
        main_dishes = items.select(&:main_dish?).dup

        build_recommendations_from(main_dishes)
      end

      def try_finding_side_dishes
        side_dishes = items.select(&:side_dish?).dup

        build_recommendations_from(side_dishes)
      end

      def build_recommendations_from(selected_items)
        budget_remaining = budget_post_tax

        [].tap do |recs|
          while budget_remaining != 0
            available_items = selected_items.select { |item| item.under?(budget_remaining) && !item.matches_blacklist?(keyword_blacklist) }

            if available_items.any?
              item = available_items.delete(available_items.sample)
              recs.push(item)
              budget_remaining -= item.price
            else
              budget_remaining = 0
            end
          end
        end
      end
    end
  end
end