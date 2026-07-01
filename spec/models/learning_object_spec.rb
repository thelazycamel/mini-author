require "rails_helper"

RSpec.describe LearningObject, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:site) }
    it { is_expected.to validate_presence_of(:lo) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:site) }
  end
end
