class Account < ApplicationRecord
  has_many :entries, dependent: :restrict_with_exception

  before_destroy :prevent_destroy

  enum :direction, {
    debit: "debit",
    credit: "credit"
  }

  validates :direction, presence: true
  validates :balance_cents, numericality: true

  private

  def prevent_destroy
    throw(:abort)
  end
end
