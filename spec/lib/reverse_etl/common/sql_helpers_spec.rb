# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReverseEtl::Common::SqlHelpers do
  include ReverseEtl::Common::SqlHelpers

  describe "#to_count_query" do
    it "converts a basic query into a count query" do
      query = "SELECT * FROM users"
      expect(to_count_query(query)).to eq("SELECT COUNT(*) FROM (SELECT * FROM users) AS subquery")
    end

    it "converts a complex query with JOINs into a count query" do
      query = "SELECT users.name, orders.total FROM users INNER JOIN orders ON users.id = orders.user_id"
      expect(to_count_query(query)).to eq("SELECT COUNT(*) FROM (SELECT users.name, orders.total FROM users INNER JOIN orders ON users.id = orders.user_id) AS subquery")
    end
  end

  describe "#add_filter_to_query" do
    let(:filter) { "active = true" }

    context "when the query does not have a WHERE clause" do
      let(:query) { "SELECT * FROM users" }

      it "adds a WHERE clause to the query" do
        expect(add_filter_to_query(query, filter)).to eq("SELECT WHERE (#{filter}) * FROM users")
      end
    end

    context "when the query already has a WHERE clause" do
      let(:query) { "SELECT * FROM users WHERE age > 30" }

      it "appends the new condition with AND" do
        expect(add_filter_to_query(query, filter)).to eq("SELECT * FROM users WHERE (#{filter}) AND age > 30")
      end
    end
  end
end
