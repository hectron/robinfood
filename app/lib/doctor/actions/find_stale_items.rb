# Finds items that can be deleted from the database
#
module Doctor
  module Actions
    class FindStaleItems
      include Verbalize::Action

      def call
        results = ActiveRecord::Base.connection.execute(query)

        ids_to_delete = results.flat_map do |result|
          ids      = result['food_item_ids']
          item_ids = (ids.gsub(/({|})/, '')&.split(',') || []).map(&:to_i).sort

          if item_ids.size > 1
            item_ids.sort[0...-1]
          end
        end

        ids_to_delete.compact.uniq
      end

      private

      # This is a query that aggregates every item that we have by restaurant, name and price
      # That way any price changes are returned in a separate row
      def query
        <<~SQL
          SELECT
            name AS item_name
            , restaurant
            , price
            , array_agg(id) AS food_item_ids
          FROM
            food_items
          WHERE
          -- Ensures that we only get items we haven't yet posted
            date_offered < now()::date
          GROUP BY
            restaurant, item_name, price
          ORDER BY
            restaurant, item_name DESC;
        SQL
      end
    end
  end
end