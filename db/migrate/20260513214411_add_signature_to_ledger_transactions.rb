class AddSignatureToLedgerTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :ledger_transactions, :signature, :string
  end
end
