require "rails_helper"

RSpec.describe Account, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:entries).dependent(:restrict_with_exception) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:direction) }
  end

  describe "callbacks" do
    it "does not allow deletion" do
      account = described_class.create!(name: "Cash", direction: "debit")

      expect(account.destroy).to be(false)
      expect(described_class.exists?(account.id)).to be(true)
    end
  end

  describe "#balance_cents" do
    let(:ledger_transaction) do
      LedgerTransaction.create!(
        name: "Sale",
        signature: SecureRandom.uuid
      )
    end

    context "when account direction is debit" do
      let(:account) do
        Account.create!(
          name: "Cash",
          direction: "debit"
        )
      end

      it "calculates balance correctly" do
        Entry.create!(
          account: account,
          ledger_transaction: ledger_transaction,
          direction: "debit",
          amount_cents: 1000
        )

        Entry.create!(
          account: account,
          ledger_transaction: ledger_transaction,
          direction: "credit",
          amount_cents: 300
        )

        expect(account.balance_cents).to eq(700)
      end
    end

    context "when account direction is credit" do
      let(:account) do
        Account.create!(
          name: "Revenue",
          direction: "credit"
        )
      end

      it "calculates balance correctly" do
        Entry.create!(
          account: account,
          ledger_transaction: ledger_transaction,
          direction: "credit",
          amount_cents: 1000
        )

        Entry.create!(
          account: account,
          ledger_transaction: ledger_transaction,
          direction: "debit",
          amount_cents: 300
        )

        expect(account.balance_cents).to eq(700)
      end
    end
  end
end
