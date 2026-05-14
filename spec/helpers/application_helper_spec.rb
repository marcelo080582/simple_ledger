require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#format_money" do
    it "formats cents into BRL currency" do
      expect(helper.format_money(1050)).to eq("R$10,50")
    end

    it "formats zero correctly" do
      expect(helper.format_money(0)).to eq("R$0,00")
    end
  end
end
