require "rails_helper"

RSpec.describe LedgerTransaction, type: :model do
  subject(:ledger_transaction) do
    described_class.new(
      name: "Sale",
      signature: "sale-signature"
    )
  end

  describe "associations" do
    it { is_expected.to have_many(:entries).dependent(:restrict_with_exception) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:signature) }
  end

  describe "callbacks" do
    it "does not allow deletion" do
      ledger_transaction.save!

      expect(ledger_transaction.destroy).to be(false)
      expect(described_class.exists?(ledger_transaction.id)).to be(true)
    end
  end
end
