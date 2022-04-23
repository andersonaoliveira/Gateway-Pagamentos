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

ActiveRecord::Schema.define(version: 2022_02_18_181108) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "card_banners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_instalments"
    t.float "discount"
    t.float "percentual_tax"
    t.float "max_tax"
    t.integer "status", default: 1
    t.index ["name"], name: "index_card_banners_on_name", unique: true
  end

  create_table "charges", force: :cascade do |t|
    t.integer "id_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.integer "qty_instalments"
    t.string "credit_card_token"
    t.decimal "order_value", precision: 8, scale: 2
    t.string "cupom_code"
    t.string "client_eni"
    t.string "return"
    t.string "product_group_id"
    t.decimal "total_charge"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.integer "sale_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["code"], name: "index_coupons_on_code", unique: true
    t.index ["sale_id"], name: "index_coupons_on_sale_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "holder_name"
    t.string "number"
    t.integer "card_banner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "valid_date"
    t.string "cpf"
    t.string "token"
    t.string "security_code"
    t.index ["card_banner_id"], name: "index_credit_cards_on_card_banner_id"
    t.index ["number"], name: "index_credit_cards_on_number", unique: true
    t.index ["token"], name: "index_credit_cards_on_token", unique: true
  end

  create_table "sales", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "expiration_date"
    t.float "discount"
    t.float "max_value"
    t.integer "quantity"
    t.integer "product_group_id"
    t.integer "status", default: 0
    t.integer "admin_id", null: false
    t.integer "approver_id"
    t.string "return_code"
    t.index ["admin_id"], name: "index_sales_on_admin_id"
    t.index ["approver_id"], name: "index_sales_on_approver_id"
    t.index ["name"], name: "index_sales_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "coupons", "sales"
  add_foreign_key "credit_cards", "card_banners"
  add_foreign_key "sales", "admins"
  add_foreign_key "sales", "admins", column: "approver_id"
end
