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

ActiveRecord::Schema[7.1].define(version: 2025_11_27_045924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administrators", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "neighbor_id", null: false
    t.bigint "common_space_id", null: false
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["common_space_id"], name: "index_bookings_on_common_space_id"
    t.index ["neighbor_id"], name: "index_bookings_on_neighbor_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "community_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["community_id"], name: "index_chats_on_community_id"
  end

  create_table "common_expenses", force: :cascade do |t|
    t.bigint "community_id", null: false
    t.datetime "date"
    t.integer "total", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_common_expenses_on_community_id"
  end

  create_table "common_spaces", force: :cascade do |t|
    t.bigint "community_id", null: false
    t.string "name"
    t.string "description"
    t.integer "price"
    t.boolean "is_available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_common_spaces_on_community_id"
  end

  create_table "communities", force: :cascade do |t|
    t.bigint "administrator_id", null: false
    t.string "name"
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.index ["administrator_id"], name: "index_communities_on_administrator_id"
  end

  create_table "expense_details", force: :cascade do |t|
    t.bigint "common_expense_id", null: false
    t.string "detail"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["common_expense_id"], name: "index_expense_details_on_common_expense_id"
  end

  create_table "expense_details_neighbors", force: :cascade do |t|
    t.bigint "expense_detail_id", null: false
    t.bigint "neighbor_id", null: false
    t.boolean "paid", default: false, null: false
    t.decimal "amount_due", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["expense_detail_id", "neighbor_id"], name: "index_expense_details_neighbors_on_detail_and_neighbor"
    t.index ["neighbor_id", "expense_detail_id"], name: "index_expense_details_neighbors_on_neighbor_and_detail"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.string "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "neighbors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "community_id", null: false
    t.float "common_expense_fraction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.boolean "is_accepted", default: false
    t.index ["community_id"], name: "index_neighbors_on_community_id"
    t.index ["user_id"], name: "index_neighbors_on_user_id"
  end

  create_table "show_chats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_id", null: false
    t.boolean "is_hidden", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_show_chats_on_chat_id"
    t.index ["user_id"], name: "index_show_chats_on_user_id"
  end

  create_table "usable_hours", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer "weekday"
    t.bigint "common_space_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["common_space_id"], name: "index_usable_hours_on_common_space_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.string "picture"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "administrators", "users"
  add_foreign_key "bookings", "common_spaces"
  add_foreign_key "bookings", "neighbors"
  add_foreign_key "chats", "communities"
  add_foreign_key "common_expenses", "communities"
  add_foreign_key "common_spaces", "communities"
  add_foreign_key "communities", "administrators"
  add_foreign_key "expense_details", "common_expenses"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "neighbors", "communities"
  add_foreign_key "neighbors", "users"
  add_foreign_key "show_chats", "chats"
  add_foreign_key "show_chats", "users"
  add_foreign_key "usable_hours", "common_spaces"
end
