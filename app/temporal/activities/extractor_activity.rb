# frozen_string_literal: true

module Activities
  class ExtractorActivity < Temporal::Activity
    def execute
      puts "ExtractorActivity.execute"
    end
  end
end
