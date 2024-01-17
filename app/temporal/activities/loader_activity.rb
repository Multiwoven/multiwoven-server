# frozen_string_literal: true

module Activities
  class LoaderActivity < Temporal::Activity
    def execute
      puts "ExtractorActivity.execute"
    end
  end
end
