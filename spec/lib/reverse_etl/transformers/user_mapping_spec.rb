# frozen_string_literal: true

RSpec.describe ReverseEtl::Transformers::UserMapping do
  describe "#transform" do
    let(:extractor) { ReverseEtl::Transformers::UserMapping.new }

    context "with complex mapping including arrays and nested structures" do
      let(:sync) { instance_double("Sync", configuration: mapping) }
      let(:mapping) do
        {
          "CC_ZIP" => "attributes.properties.zip_code[]",
          "CC_CITY" => "attributes.properties.city[]",
          "NAME" => "attributes.properties.name"

        }
      end

      let(:source_data) do
        {
          "CC_ZIP" => "12345",
          "CC_CITY" => "Some City",
          "NAME" => "Some Name"
        }
      end
      let(:sync_records) { [source_data] }

      it "correctly handles complex transformations for each record" do
        results = extractor.transform(sync, sync_records)
        expected_result = [
          {
            "attributes" => {
              "properties" => {
                "zip_code" => ["12345"],
                "city" => ["Some City"],
                "name" => "Some Name"
              }
            }
          }
        ]

        expect(results).to eq(expected_result)
      end
    end
  end
end
