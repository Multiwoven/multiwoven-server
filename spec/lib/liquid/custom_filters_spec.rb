# frozen_string_literal: true

require "rails_helper"

RSpec.describe Liquid::CustomFilters do
  include Liquid::CustomFilters

  describe ".cast" do
    it "casts input to string" do
      expect(cast(123, "string")).to eq("123")
    end

    it "casts input to number" do
      expect(cast("123.45", "number")).to eq(123.45)
    end

    it "casts non-numeric input to number as 0" do
      expect(cast("abc", "number")).to eq(0)
    end

    it "casts input to boolean" do
      expect(cast("true", "boolean")).to be true
    end
  end

  describe ".includes" do
    it "returns true if input includes substring" do
      expect(includes("hello world", "world")).to be true
    end

    it "returns false if input does not include substring" do
      expect(includes("hello world", "mars")).to be false
    end
  end

  describe ".regex_replace" do
    it "replaces matching substrings" do
      expect(regex_replace("hello world", "world", "mars")).to eq("hello mars")
    end

    it "supports regex flags" do
      expect(regex_replace("Hello World", "world", "mars", "i")).to eq("Hello mars")
    end
  end

  describe ".regex_test" do
    it "returns true if input matches the pattern" do
      expect(regex_test("hello world", "world")).to be true
    end

    it "returns false if input does not match the pattern" do
      expect(regex_test("hello world", "^world")).to be false
    end

    it "supports regex flags" do
      expect(regex_test("Hello World", "hello", "", "i")).to be true
    end
  end
end
