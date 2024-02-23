# frozen_string_literal: true

module ReverseEtl
  module Transformers
    class UserMapping < Base
      attr_accessor :mappings, :record, :destination_data

      def transform(sync, sync_record)
        @mappings = sync.configuration
        @record = sync_record.record
        @destination_data = {}

        if mappings.is_a?(Array)
          transform_record_v2
        else
          transform_record_v1
        end

        destination_data
      rescue StandardError => e
        Temporal.logger.error(error_message: e.message,
                              sync_run_id: sync_run.id,
                              stack_trace: Rails.backtrace_cleaner.clean(e.backtrace))
      end

      private

      def transform_record_v1 # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
        mappings.each do |source_key, dest_path|
          dest_keys = dest_path.split(".")
          current = destination_data

          dest_keys.each_with_index do |key, index|
            if index == dest_keys.length - 1
              # Handle array notation in the path
              if key.include?("[]")
                array_key = key.gsub("[]", "")
                current[array_key] ||= []
                current[array_key] << record[source_key]
              else
                current[key] = record[source_key]
              end
            elsif key.include?("[]")
              array_key = key.gsub("[]", "")
              current[array_key] ||= []
              # Use the last element of the array or create a new one if empty
              current = current[array_key].last || current[array_key].push({}).last
            else
              current[key] ||= {}
              current = current[key]
            end
          end
        end
      end

      def transform_record_v2
        mappings.each do |mapping|
          mapping = mapping.with_indifferent_access
          case mapping[:mapping_type]
          when "standard"
            standard_mapping(mapping)
          when "static"
            static_mapping(mapping)
          when "template"
            template_mapping(mapping)
          end
        end
      end

      def standard_mapping(mapping)
        dest_keys = mapping[:to].split(".")
        source_key = mapping[:from]
        current = destination_data

        dest_keys.each_with_index do |key, index|
          if index == dest_keys.length - 1
            # Handle array notation in the path
            if key.include?("[]")
              array_key = key.gsub("[]", "")
              current[array_key] ||= []
              current[array_key] << record[source_key]
            else
              current[key] = record[source_key]
            end
          elsif key.include?("[]")
            array_key = key.gsub("[]", "")
            current[array_key] ||= []
            # Use the last element of the array or create a new one if empty
            current = current[array_key].last || current[array_key].push({}).last
          else
            current[key] ||= {}
            current = current[key]
          end
        end
      end

      def static_mapping(mapping)
        dest_keys = mapping[:to].split(".")
        static_value = mapping[:value]
        current = destination_data

        dest_keys.each_with_index do |key, index|
          if index == dest_keys.length - 1
            # Handle array notation in the path
            if key.include?("[]")
              array_key = key.gsub("[]", "")
              current[array_key] ||= []
              current[array_key] << static_value
            else
              current[key] = static_value
            end
          elsif key.include?("[]")
            array_key = key.gsub("[]", "")
            current[array_key] ||= []
            # Use the last element of the array or create a new one if empty
            current[array_key].last || current[array_key].push({}).last
          else
            current[key] ||= {}
            current[key]
          end
        end
      end

      def template_mapping(mapping)
        dest_keys = mapping[:to].split(".")
        template = mapping[:template]
        template = Liquid::Template.parse(template)
        rendered_text = template.render(record)
        current = destination_data

        dest_keys.each_with_index do |key, index|
          if index == dest_keys.length - 1
            # Handle array notation in the path
            if key.include?("[]")
              array_key = key.gsub("[]", "")
              current[array_key] ||= []
              current[array_key] << rendered_text
            else
              current[key] = rendered_text
            end
          elsif key.include?("[]")
            array_key = key.gsub("[]", "")
            current[array_key] ||= []
            # Use the last element of the array or create a new one if empty
            current[array_key].last || current[array_key].push({}).last
          else
            current[key] ||= {}
            current[key]
          end
        end
      end
    end
  end
end
