class Entry < ApplicationRecord
  belongs_to :ledger_transaction
  belongs_to :account

  enum :direction, {
    debit: "debit",
    credit: "credit"
  }

  validates :direction, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }
end
