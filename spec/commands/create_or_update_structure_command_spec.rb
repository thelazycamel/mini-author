require "rails_helper"

RSpec.describe CreateOrUpdateStructureCommand do
  let(:site) do
    create(:site,
      domain: "http://importer",
      port: "8080",
      structure_path: "internal/api/v1/structures"
    )
  end

  describe "#execute for create" do
    let(:structure) { Structure.new(name: "Test Course", site: site, structure_xml: xml_upload) }
    let(:xml_upload) do
      file = Tempfile.new(["structure", ".xml"])
      file.write("<structure><node/></structure>")
      file.rewind
      Rack::Test::UploadedFile.new(file.path, "application/xml")
    end

    context "when the importer API succeeds" do
      before do
        stub_request(:post, "http://importer:8080/internal/api/v1/structures")
          .to_return(
            status: 202,
            body: { data: { id: "42", type: "structures", attributes: { name: "Test Course" } } }.to_json,
            headers: { "Content-Type" => "application/vnd.api+json" }
          )
      end

      it "saves the structure and stores the importer response ID" do
        described_class.execute(structure)

        expect(structure).to be_persisted
        expect(structure.upload_response).to eq("42")
        expect(structure.course_id).to eq("42")
      end

      it "sends a POST with the structure_xml_url pointing to local-author" do
        described_class.execute(structure)

        expect(WebMock).to have_requested(:post, "http://importer:8080/internal/api/v1/structures")
          .with { |req|
            body = JSON.parse(req.body)
            body.dig("data", "attributes", "structure_xml_url")&.start_with?("http://local_author:8084")
          }
      end
    end

    context "when the importer API fails" do
      before do
        stub_request(:post, "http://importer:8080/internal/api/v1/structures")
          .to_return(status: 422, body: { errors: [{ detail: "Invalid" }] }.to_json)
      end

      it "raises an error" do
        expect { described_class.execute(structure) }.to raise_error(RestClient::UnprocessableEntity)
      end
    end
  end

  describe "#execute for update" do
    let(:structure) { create(:structure, site: site, course_id: "42") }

    before do
      stub_request(:post, "http://importer:8080/internal/api/v1/structures")
        .to_return(
          status: 202,
          body: { data: { id: "42", type: "structures", attributes: { name: "Test" } } }.to_json,
          headers: { "Content-Type" => "application/vnd.api+json" }
        )
      stub_request(:put, "http://importer:8080/internal/api/v1/structures/42")
        .to_return(
          status: 200,
          body: { data: { id: "42", type: "structures", attributes: { name: "Updated Course" } } }.to_json,
          headers: { "Content-Type" => "application/vnd.api+json" }
        )
    end

    it "sends a PUT to the importer with the course ID" do
      described_class.execute(structure, { name: "Updated Course" })

      expect(WebMock).to have_requested(:put, "http://importer:8080/internal/api/v1/structures/42")
      expect(structure.reload.name).to eq("Updated Course")
    end
  end
end
