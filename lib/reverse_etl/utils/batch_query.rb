module ReverseEtl
  module Utils
    class BatchQuery
      def self.execute_in_batches(params)
        raise ArgumentError, "Batch size must be greater than 0" if params[:batch_size] <= 0

        total_records = params[:limit]
        current_offset = params[:offset]

        while current_offset < params[:offset] + total_records

          # Total records might not exaclty splitted into batch size
          current_limit = [
            params[:batch_size],
            params[:offset] + total_records - current_offset
          ].min

          # Set limit and offset into sync dynamically
          params[:sync_config].limit = current_limit
          params[:sync_config].offset = current_offset

          # Execute the batch query
          result = params[:client].execute(params[:sync_config])

          yield result if block_given?

          # Break if no records are found in the current batch
          break if result.size < current_limit

          # increment batch size
          current_offset += params[:batch_size]
        end
      end
    end
  end
end
