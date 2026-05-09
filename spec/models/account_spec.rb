require "rails_helper"

RSpec.describe Account, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:entries).dependent(:restrict_with_exception) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:direction) }
    it { is_expected.to validate_numericality_of(:balance_cents) }
  end
end
