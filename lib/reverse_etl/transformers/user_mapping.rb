# frozen_string_literal: true

module ReverseEtl
  module Transformers
    class UserMapping < Base
      def transform(sync, record_datum)
        mapping = sync.configuration
        record_datum.map do |record_data|
          transform_record(record_data, mapping)
        rescue StandardError => e
          Rails.logger.error("Error transforming record: #{e.message}")
          nil
        end
      end

      private

      def transform_record(source_data, mapping)
        mapping.each_with_object({}) do |(source_key, dest_path), destination_data|
          insert_value(destination_data, dest_path.split("."), source_data[source_key])
        end
      end

      # Only god knows how this method works !!!
      def insert_value(destination, keys, value) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
        last_key = keys.pop

        current = keys.reduce(destination) do |current_dest, key|
          key, is_array = key.end_with?("[]") ? [key[0...-2], true] : [key, false]
          is_array ? (current_dest[key] ||= []).last || current_dest[key].push({}) : (current_dest[key] ||= {})
        end

        if last_key.end_with?("[]")
          (current[last_key[0...-2]] ||= []) << value
        else
          current[last_key] = value
        end
      end
    end
  end
end
