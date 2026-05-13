require "rails_helper"

RSpec.describe Account, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:entries).dependent(:restrict_with_exception) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:direction) }
    it { is_expected.to validate_numericality_of(:balance_cents) }
  end

  describe "callbacks" do
    it "does not allow deletion" do
      account = described_class.create!(name: "Cash", direction: "debit")

      expect(account.destroy).to be(false)
      expect(described_class.exists?(account.id)).to be(true)
    end
  end
end
