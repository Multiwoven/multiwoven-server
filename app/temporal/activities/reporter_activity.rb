# frozen_string_literal: true

module Activities
  class ReporterActivity < Temporal::Activity
    def execute
      puts "ReporterActivity.execute"
    end
  end
end
