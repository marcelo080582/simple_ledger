require 'rails_helper'

RSpec.describe LedgerTransactions::CreateService do
  describe '#call' do
    let(:cash_account) { Account.create!(name: 'Cash', direction: 'debit') }
    let(:revenue_account) { Account.create!(name: 'Revenue', direction: 'credit') }

    context 'when entries are balanced' do
      it 'creates a ledger transaction with entries' do
        result = described_class.new(
          name: 'Initial deposit',
          entries_attributes: [
            { account_id: cash_account.id, direction: 'debit', amount_cents: 10_000 },
            { account_id: revenue_account.id, direction: 'credit', amount_cents: 10_000 }
          ]
        ).call

        expect(result).to be_success
        expect(result.ledger_transaction).to be_persisted
        expect(result.ledger_transaction.entries.count).to eq(2)
      end
    end

    context 'when entries are unbalanced' do
      it 'does not create the ledger transaction' do
        result = described_class.new(
          name: 'Invalid transaction',
          entries_attributes: [
            { account_id: cash_account.id, direction: 'debit', amount_cents: 10_000 },
            { account_id: revenue_account.id, direction: 'credit', amount_cents: 5_000 }
          ]
        ).call

        expect(result).not_to be_success
        expect(result.ledger_transaction).to be_nil
        expect(result.errors).to include('Debits and credits must be equal')
      end
    end
  end
end
