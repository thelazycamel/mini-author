require "rails_helper"

RSpec.describe Site, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:domain) }
  end

  describe "associations" do
    it { is_expected.to have_many(:learning_objects).dependent(:restrict_with_error) }
  end

  describe "deletion" do
    it "cannot be destroyed when learning objects exist" do
      site = create(:site)
      create(:learning_object, site: site)

      expect(site.destroy).to be false
      expect(site.errors).not_to be_empty
    end

    it "can be destroyed when no learning objects exist" do
      site = create(:site)
      expect(site.destroy).to be_truthy
    end
  end
end
