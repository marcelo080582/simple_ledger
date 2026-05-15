class DashboardController < ApplicationController
  def index
    @accounts = Account.order(:name)

    @ledger_transactions = LedgerTransaction.includes(entries: :account).order(created_at: :desc)

    @accounts_count = Account.count
    @transactions_count = LedgerTransaction.count
  end
end
