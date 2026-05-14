class AddCheckConstraintsToEntries < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :entries, "amount_cents > 0", name: "entries_amount_cents_positive"

    add_check_constraint :entries, "direction IN ('debit', 'credit')", name: "entries_direction_valid"
  end
end
