class Account < ApplicationRecord
  has_many :entries, dependent: :restrict_with_exception

  enum :direction, {
    debit: "debit",
    credit: "credit"
  }

  validates :direction, presence: true
  validates :balance_cents, numericality: true
end
