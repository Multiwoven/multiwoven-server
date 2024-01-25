# frozen_string_literal: true

module Connectors
  class QuerySource
    include Interactor

    def call
      result = Models::ExecuteQuery.call(
        connector: context.connector,
        query: context.query,
        limit: context.limit
      )
      if result["errors"].present?
        context.fail!(error: (result["errors"]).to_s)
      else
        context.records = result.records
      end
    rescue StandardError => e
      context.fail!(errors: e.message)
    end
  end
end
