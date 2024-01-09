# frozen_string_literal: true

module ReverseEtl
  module Extractors
    class Base
      def read(_sync_run_id)
        raise "Not implemented"
      end
    end
  end
end
