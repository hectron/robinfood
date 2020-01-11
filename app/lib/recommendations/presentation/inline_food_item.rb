module Recommendations
  module Presentation
    class InlineFoodItem
      # @!attribute [r] item
      #   @return [FoodItem]
      attr_reader :item

      def initialize(item)
        @item = item
      end

      def link
        "[#{item.name} from #{item.restaurant}](#{item.url})"
      end

      def dietary_restrictions(exceptions: [])
        restrictions = item.dietary_restrictions.reject {|r| exceptions.include?(r) }

        if restrictions.any?
          "(#{restrictions.join(', ')})"
        end
      end

      def price
        "$#{'%.2f' % item.price.to_s}"
      end
    end
  end
end