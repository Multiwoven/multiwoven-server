# frozen_string_literal: true

module ReverseEtl
  module Loaders
    class Base
      def write(_sync_config, _records)
        raise "Not implemented"
      end
    end
  end
end
