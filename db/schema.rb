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

ActiveRecord::Schema[8.1].define(version: 2026_05_25_100000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clients", force: :cascade do |t|
    t.text "address"
    t.string "city"
    t.bigint "company_id", null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.string "dic"
    t.string "email"
    t.string "first_name"
    t.string "ic_dph"
    t.string "ico"
    t.string "kind", default: "company", null: false
    t.string "last_name"
    t.string "name", null: false
    t.text "note"
    t.string "phone"
    t.string "postal_code"
    t.string "street"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["company_id"], name: "index_clients_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "city", null: false
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.string "dic"
    t.string "ic_dph"
    t.string "ico", null: false
    t.string "name", null: false
    t.string "postal_code", null: false
    t.string "street", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "expense_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "expense_id", null: false
    t.string "name", null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.decimal "tax_rate", precision: 5, scale: 2, default: "23.0", null: false
    t.decimal "unit_price", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_expense_items_on_expense_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.string "category"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "currency"
    t.date "date"
    t.text "note"
    t.string "payment_method"
    t.datetime "updated_at", null: false
    t.string "vendor"
    t.string "vendor_city"
    t.string "vendor_country"
    t.string "vendor_dic"
    t.string "vendor_ic_dph"
    t.string "vendor_ico"
    t.bigint "vendor_id"
    t.string "vendor_postal_code"
    t.string "vendor_street"
    t.index ["company_id"], name: "index_expenses_on_company_id"
    t.index ["vendor_id"], name: "index_expenses_on_vendor_id"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "invoice_id", null: false
    t.string "name", null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.decimal "tax_rate", precision: 5, scale: 2, default: "23.0", null: false
    t.decimal "unit_price", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.text "client_address"
    t.string "client_city"
    t.string "client_country"
    t.string "client_dic"
    t.string "client_ic_dph"
    t.string "client_ico"
    t.bigint "client_id"
    t.string "client_name"
    t.string "client_postal_code"
    t.string "client_street"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "currency"
    t.date "due_on"
    t.date "issued_on"
    t.text "note"
    t.string "number"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["company_id"], name: "index_invoices_on_company_id"
  end

  create_table "mission_progresses", force: :cascade do |t|
    t.datetime "claimed_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "mission_key", null: false
    t.string "period", null: false
    t.date "period_start", null: false
    t.integer "progress", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "mission_key", "period", "period_start"], name: "index_mission_progresses_on_user_mission_period", unique: true
    t.index ["user_id"], name: "index_mission_progresses_on_user_id"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.string "achievement_key", null: false
    t.datetime "awarded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "achievement_key"], name: "index_user_achievements_on_user_id_and_achievement_key", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "achievement_reward_10_claimed_at"
    t.datetime "achievement_reward_15_claimed_at"
    t.datetime "achievement_reward_20_claimed_at"
    t.datetime "achievement_reward_5_claimed_at"
    t.datetime "created_at", null: false
    t.integer "current_login_streak", default: 0, null: false
    t.string "email", null: false
    t.date "last_login_on"
    t.integer "login_count", default: 0, null: false
    t.datetime "login_streak_reward_3_claimed_at"
    t.datetime "login_streak_reward_7_claimed_at"
    t.string "password_digest", null: false
    t.integer "total_login_days", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.integer "xp", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.text "address"
    t.string "city"
    t.bigint "company_id", null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.string "dic"
    t.string "email"
    t.string "first_name"
    t.string "ic_dph"
    t.string "ico"
    t.string "kind", default: "company", null: false
    t.string "last_name"
    t.string "name", null: false
    t.text "note"
    t.string "phone"
    t.string "postal_code"
    t.string "street"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["company_id"], name: "index_vendors_on_company_id"
  end

  add_foreign_key "clients", "companies"
  add_foreign_key "companies", "users"
  add_foreign_key "expense_items", "expenses"
  add_foreign_key "expenses", "companies"
  add_foreign_key "expenses", "vendors"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "companies"
  add_foreign_key "mission_progresses", "users"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "vendors", "companies"
end
