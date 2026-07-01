require "rails_helper"

RSpec.describe CreateOrUpdateLearningObjectCommand do
  let(:site) { create(:site, domain: "https://cdn.example.com", path: "/upload", port: nil) }
  let(:lo_file) do
    file = Tempfile.new(["test", ".zip"])
    file.write("zip content")
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "application/zip")
  end

  describe "#execute for create" do
    let(:learning_object) { LearningObject.new(name: "Test LO", site: site, lo: lo_file) }

    context "when the external API succeeds" do
      before do
        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 200, body: { "IdentId" => "ABC123" }.to_json, headers: { "Content-Type" => "application/json" })
      end

      it "uploads to the external site and saves the record" do
        described_class.execute(learning_object)

        expect(learning_object).to be_persisted
        expect(learning_object.upload_response).to eq("ABC123")
      end

      it "sends a PUT request to the external site" do
        described_class.execute(learning_object)

        expect(WebMock).to have_requested(:put, "https://cdn.example.com/upload")
      end
    end

    context "when the site has a port" do
      let(:site) { create(:site, domain: "https://cdn.example.com", path: "/upload", port: "8443") }

      before do
        stub_request(:put, "https://cdn.example.com:8443/upload")
          .to_return(status: 200, body: { "IdentId" => "DEF456" }.to_json, headers: { "Content-Type" => "application/json" })
      end

      it "constructs URL with port" do
        described_class.execute(learning_object)

        expect(learning_object.upload_response).to eq("DEF456")
        expect(WebMock).to have_requested(:put, "https://cdn.example.com:8443/upload")
      end
    end

    context "when info_xml is present" do
      let(:info_xml_file) do
        file = Tempfile.new(["info", ".xml"])
        file.write("<info/>")
        file.rewind
        Rack::Test::UploadedFile.new(file.path, "application/xml")
      end
      let(:learning_object) { LearningObject.new(name: "Test LO", site: site, lo: lo_file, info_xml: info_xml_file) }

      before do
        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 200, body: { "IdentId" => "GHI789" }.to_json, headers: { "Content-Type" => "application/json" })
      end

      it "includes LearningObjectInfo in the payload" do
        described_class.execute(learning_object)

        expect(learning_object).to be_persisted
        expect(learning_object.upload_response).to eq("GHI789")
      end
    end

    context "when the external API fails" do
      before do
        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 500, body: "Internal Server Error")
      end

      it "raises an error and does not persist the record" do
        expect { described_class.execute(learning_object) }.to raise_error(RestClient::InternalServerError)
        expect(learning_object).not_to be_persisted
      end
    end
  end

  describe "#execute for update" do
    before do
      stub_request(:put, "https://cdn.example.com/upload")
        .to_return(status: 200, body: { "IdentId" => "NEW456" }.to_json, headers: { "Content-Type" => "application/json" })
    end

    let(:learning_object) { create(:learning_object, site: site, upload_response: "OLD123") }

    context "when the external API succeeds" do
      it "re-uploads and updates the upload_response" do
        described_class.execute(learning_object, { name: "Updated Name" })

        learning_object.reload
        expect(learning_object.name).to eq("Updated Name")
        expect(learning_object.upload_response).to eq("NEW456")
      end
    end

    context "when the external API fails on update" do
      it "raises an error and does not persist changes" do
        learning_object

        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 503, body: "Service Unavailable")

        expect {
          described_class.execute(learning_object, { name: "Should Not Save" })
        }.to raise_error(RestClient::ServiceUnavailable)

        learning_object.reload
        expect(learning_object.name).not_to eq("Should Not Save")
      end
    end
  end
end
