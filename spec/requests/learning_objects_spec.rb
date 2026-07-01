require "rails_helper"

RSpec.describe "LearningObjects", type: :request do
  let(:site) { create(:site, domain: "https://cdn.example.com", path: "/upload", port: nil) }

  let(:lo_upload) do
    file = Tempfile.new(["test", ".zip"])
    file.write("zip content")
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "application/zip")
  end

  before do
    stub_request(:put, "https://cdn.example.com/upload")
      .to_return(status: 200, body: { "IdentId" => "STUB123" }.to_json, headers: { "Content-Type" => "application/json" })
  end

  describe "GET /learning_objects" do
    it "returns a successful response" do
      get learning_objects_path
      expect(response).to have_http_status(:ok)
    end

    it "displays all learning objects" do
      create(:learning_object, name: "LO One", site: site)

      get learning_objects_path
      expect(response.body).to include("LO One")
    end
  end

  describe "GET /learning_objects/new" do
    it "returns a successful response" do
      get new_learning_object_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /learning_objects" do
    context "when external upload succeeds" do
      it "creates a learning object and redirects" do
        post learning_objects_path, params: {
          learning_object: {
            name: "New LO",
            site_id: site.id,
            lo: lo_upload
          }
        }

        expect(response).to redirect_to(learning_objects_path)
        follow_redirect!
        expect(response.body).to include("Created Successfully")
      end
    end

    context "when external upload fails" do
      before do
        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 500, body: "Error")
      end

      it "re-renders the form with an error" do
        post learning_objects_path, params: {
          learning_object: {
            name: "New LO",
            site_id: site.id,
            lo: lo_upload
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Something went wrong")
      end
    end
  end

  describe "GET /learning_objects/:id/edit" do
    it "returns a successful response" do
      lo = create(:learning_object, site: site)
      get edit_learning_object_path(lo)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /learning_objects/:id" do
    let(:learning_object) { create(:learning_object, site: site) }

    context "when external upload succeeds" do
      it "updates the learning object and redirects" do
        patch learning_object_path(learning_object), params: {
          learning_object: { name: "Updated Name" }
        }

        expect(response).to redirect_to(learning_objects_path)
        expect(learning_object.reload.name).to eq("Updated Name")
      end
    end

    context "when external upload fails" do
      before do
        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 500, body: "Error")
      end

      it "re-renders the form with an error" do
        # Create with success first
        learning_object

        # Now stub failure
        stub_request(:put, "https://cdn.example.com/upload")
          .to_return(status: 500, body: "Error")

        patch learning_object_path(learning_object), params: {
          learning_object: { name: "Updated Name" }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Something went wrong")
      end
    end
  end

  describe "DELETE /learning_objects/:id" do
    it "destroys the learning object and redirects" do
      lo = create(:learning_object, site: site)

      expect {
        delete learning_object_path(lo)
      }.to change(LearningObject, :count).by(-1)

      expect(response).to redirect_to(learning_objects_path)
    end
  end
end
