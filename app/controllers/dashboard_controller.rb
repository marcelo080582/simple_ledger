class DashboardController < ApplicationController
  def index
    @accounts = Account.order(:name)
    @ledger_transactions = LedgerTransaction.includes(entries: :account).order(created_at: :desc)
  end
end
