FactoryBot.define do
  factory :entry do
    ledger_transaction { nil }
    account { nil }
    direction { "MyString" }
    amount_cents { 1 }
  end
end
