require "rails_helper"

RSpec.describe Entry, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:ledger_transaction) }
    it { is_expected.to belong_to(:account) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:direction) }
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than(0) }
  end
end
