class Account < ApplicationRecord
  has_many :entries, dependent: :restrict_with_exception

  before_destroy :prevent_destroy

  enum :direction, {
    debit: "debit",
    credit: "credit"
  }

  validates :direction, presence: true
  validates :balance_cents, numericality: true

  def balance_cents
    if debit?
      debit_entries_total - credit_entries_total
    else
      credit_entries_total - debit_entries_total
    end
  end

  private

  def prevent_destroy
    throw(:abort)
  end

  def debit_entries_total
    entries.debit.sum(:amount_cents)
  end

  def credit_entries_total
    entries.credit.sum(:amount_cents)
  end
end
