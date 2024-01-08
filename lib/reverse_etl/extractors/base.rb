# frozen_string_literal: true

module ReverseEtl
  module Extractors
    class Base
      def read(_sync_config)
        raise "Not implemented"
      end
    end
  end
end
