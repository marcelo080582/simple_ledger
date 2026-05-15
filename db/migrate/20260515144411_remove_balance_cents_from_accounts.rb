class RemoveBalanceCentsFromAccounts < ActiveRecord::Migration[8.1]
  def change
    remove_column :accounts, :balance_cents, :integer
  end
end
