require "rails_helper"

RSpec.describe "LedgerTransactions", type: :request do
  describe "POST /ledger_transactions" do
    let!(:cash_account) do
      Account.create!(
        name: "Cash",
        direction: "debit"
      )
    end

    let!(:revenue_account) do
      Account.create!(
        name: "Revenue",
        direction: "credit"
      )
    end

    it "creates a balanced transaction" do
      expect do
        post ledger_transactions_path, params: {
          ledger_transaction: {
            name: "Sale",
            entries_attributes: [
              {
                account_id: cash_account.id,
                direction: "debit",
                amount_cents: 1000
              },
              {
                account_id: revenue_account.id,
                direction: "credit",
                amount_cents: 1000
              }
            ]
          }
        }
      end.to change(LedgerTransaction, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "does not create transaction with same accounts" do
      expect do
        post ledger_transactions_path, params: {
          ledger_transaction: {
            name: "Invalid transaction",
            entries_attributes: [
              {
                account_id: cash_account.id,
                direction: "debit",
                amount_cents: 1000
              },
              {
                account_id: cash_account.id,
                direction: "credit",
                amount_cents: 1000
              }
            ]
          }
        }
      end.not_to change(LedgerTransaction, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Transaction must use different accounts")
    end
  end
end
