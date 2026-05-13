require "rails_helper"

RSpec.describe LedgerTransaction, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:entries).dependent(:restrict_with_exception) }
  end

  describe "callbacks" do
    it "does not allow deletion" do
      ledger_transaction = described_class.create!(name: "Sale")

      expect(ledger_transaction.destroy).to be(false)
      expect(described_class.exists?(ledger_transaction.id)).to be(true)
    end
  end
end
