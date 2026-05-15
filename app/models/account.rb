class Account < ApplicationRecord
  has_many :entries, dependent: :restrict_with_exception

  before_destroy :prevent_destroy

  enum :direction, {
    debit: "debit",
    credit: "credit"
  }

  validates :name, presence: true
  validates :direction, presence: true

  def balance_cents
    normal_balance_cents - opposite_balance_cents
  end

  private

  def prevent_destroy
    throw(:abort)
  end

  def normal_balance_cents
    entries.where(direction: direction).sum(:amount_cents)
  end

  def opposite_balance_cents
    entries.where.not(direction: direction).sum(:amount_cents)
  end
end
