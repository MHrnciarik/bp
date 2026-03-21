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

ActiveRecord::Schema[8.1].define(version: 2026_03_21_134500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "expense_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "expense_id", null: false
    t.string "name", null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.decimal "unit_price", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_expense_items_on_expense_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.string "currency"
    t.date "date"
    t.text "note"
    t.string "payment_method"
    t.decimal "tax_rate", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.string "vendor"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "invoice_id", null: false
    t.string "name", null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.decimal "unit_price", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.text "client_address"
    t.string "client_name"
    t.datetime "created_at", null: false
    t.string "currency"
    t.date "due_on"
    t.date "issued_on"
    t.text "note"
    t.string "number"
    t.string "status"
    t.decimal "tax_rate", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  add_foreign_key "expense_items", "expenses"
  add_foreign_key "invoice_items", "invoices"
end
