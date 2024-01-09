# frozen_string_literal: true

module ReverseEtl
  module Common
    module SqlHelpers
      def to_count_query(sql_query)
        "SELECT COUNT(*) FROM (#{sql_query}) AS subquery"
      end

      # TODO: Refactor this to support more complex SQL queries
      def add_filter_to_query(query, filter)
        if query.include?("WHERE")
          query.gsub("WHERE", "WHERE (#{filter}) AND")
        else
          query.gsub("SELECT", "SELECT WHERE (#{filter})")
        end
      end
    end
  end
end
