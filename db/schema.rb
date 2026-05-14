# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_14_214823) do
  create_table "accounts", force: :cascade do |t|
    t.integer "balance_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "direction", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "direction", null: false
    t.integer "ledger_transaction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_entries_on_account_id"
    t.index ["ledger_transaction_id"], name: "index_entries_on_ledger_transaction_id"
    t.check_constraint "amount_cents > 0", name: "entries_amount_cents_positive"
    t.check_constraint "direction IN ('debit', 'credit')", name: "entries_direction_valid"
  end

  create_table "ledger_transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "signature"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "entries", "accounts"
  add_foreign_key "entries", "ledger_transactions"
end
