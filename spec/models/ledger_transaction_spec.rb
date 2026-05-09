require "rails_helper"

RSpec.describe LedgerTransaction, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:entries).dependent(:destroy) }
  end
end
