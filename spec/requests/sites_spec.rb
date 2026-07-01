require "rails_helper"

RSpec.describe "Sites", type: :request do
  describe "GET /sites" do
    it "returns a successful response" do
      get sites_path
      expect(response).to have_http_status(:ok)
    end

    it "displays all sites" do
      create(:site, name: "Alpha Site")
      create(:site, name: "Beta Site")

      get sites_path
      expect(response.body).to include("Alpha Site")
      expect(response.body).to include("Beta Site")
    end
  end

  describe "GET /sites/new" do
    it "returns a successful response" do
      get new_site_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /sites" do
    context "with valid params" do
      let(:valid_params) { { site: { name: "New Site", domain: "https://example.com", path: "/api", port: "" } } }

      it "creates a site and redirects" do
        expect {
          post sites_path, params: valid_params
        }.to change(Site, :count).by(1)

        expect(response).to redirect_to(sites_path)
        follow_redirect!
        expect(response.body).to include("Site Created")
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { site: { name: "", domain: "" } } }

      it "does not create a site and re-renders the form" do
        expect {
          post sites_path, params: invalid_params
        }.not_to change(Site, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /sites/:id/edit" do
    it "returns a successful response" do
      site = create(:site)
      get edit_site_path(site)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /sites/:id" do
    let(:site) { create(:site) }

    context "with valid params" do
      it "updates the site and redirects" do
        patch site_path(site), params: { site: { name: "Updated Name" } }

        expect(response).to redirect_to(sites_path)
        expect(site.reload.name).to eq("Updated Name")
      end
    end

    context "with invalid params" do
      it "re-renders the form" do
        patch site_path(site), params: { site: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /sites/:id" do
    it "destroys the site and redirects" do
      site = create(:site)

      expect {
        delete site_path(site)
      }.to change(Site, :count).by(-1)

      expect(response).to redirect_to(sites_path)
    end

    it "does not destroy a site with learning objects" do
      site = create(:site)
      create(:learning_object, site: site)

      expect {
        delete site_path(site)
      }.not_to change(Site, :count)

      expect(response).to redirect_to(sites_path)
    end
  end
end
