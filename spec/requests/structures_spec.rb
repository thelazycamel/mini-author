require "rails_helper"

RSpec.describe "Structures", type: :request do
  let(:site) do
    create(:site,
      domain: "http://importer",
      port: "8080",
      structure_path: "internal/api/v1/structures"
    )
  end

  let(:xml_upload) do
    file = Tempfile.new(["structure", ".xml"])
    file.write("<structure><node/></structure>")
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "application/xml")
  end

  before do
    stub_request(:post, /importer.*structures/)
      .to_return(
        status: 202,
        body: { data: { id: "99", type: "structures", attributes: { name: "Test" } } }.to_json,
        headers: { "Content-Type" => "application/vnd.api+json" }
      )
    stub_request(:put, /importer.*structures/)
      .to_return(
        status: 200,
        body: { data: { id: "99", type: "structures", attributes: { name: "Test" } } }.to_json,
        headers: { "Content-Type" => "application/vnd.api+json" }
      )
  end

  describe "GET /structures" do
    it "returns a successful response" do
      get structures_path
      expect(response).to have_http_status(:ok)
    end

    it "displays all structures" do
      create(:structure, name: "Course Alpha", site: site)

      get structures_path
      expect(response.body).to include("Course Alpha")
    end
  end

  describe "GET /structures/new" do
    it "returns a successful response" do
      get new_structure_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /structures" do
    context "when importer succeeds" do
      it "creates a structure and redirects" do
        post structures_path, params: {
          structure: {
            name: "New Course",
            site_id: site.id,
            structure_xml: xml_upload
          }
        }

        expect(response).to redirect_to(structures_path)
        follow_redirect!
        expect(response.body).to include("Structure Created Successfully")
      end
    end

    context "when importer fails" do
      before do
        stub_request(:post, /importer.*structures/)
          .to_return(status: 500, body: "Error")
      end

      it "re-renders the form with an error" do
        post structures_path, params: {
          structure: {
            name: "New Course",
            site_id: site.id,
            structure_xml: xml_upload
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Upload failed")
      end
    end
  end

  describe "GET /structures/:id/edit" do
    it "returns a successful response" do
      structure = create(:structure, site: site)
      get edit_structure_path(structure)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /structures/:id" do
    let(:structure) { create(:structure, site: site, course_id: "99") }

    context "when importer succeeds" do
      it "updates the structure and redirects" do
        patch structure_path(structure), params: {
          structure: { name: "Updated Name" }
        }

        expect(response).to redirect_to(structures_path)
        expect(structure.reload.name).to eq("Updated Name")
      end
    end
  end

  describe "DELETE /structures/:id" do
    it "destroys the structure and redirects" do
      structure = create(:structure, site: site)

      expect {
        delete structure_path(structure)
      }.to change(Structure, :count).by(-1)

      expect(response).to redirect_to(structures_path)
    end
  end
end
