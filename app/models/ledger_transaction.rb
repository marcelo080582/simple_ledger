class LedgerTransaction < ApplicationRecord
  has_many :entries, dependent: :restrict_with_exception

  before_destroy :prevent_destroy

  private

  def prevent_destroy
    throw(:abort)
  end
end
