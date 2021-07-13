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

ActiveRecord::Schema.define(version: 2021_07_12_235324) do

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

  create_table "administrators", force: :cascade do |t|
    t.string "name"
    t.string "identify"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "remember_digest"
  end

  create_table "facilities", force: :cascade do |t|
    t.integer "service_id", null: false
    t.string "name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "update_count"
    t.string "created_by"
    t.string "created_api_caller"
    t.string "updated_by"
    t.string "updated_api_caller"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_facilities_on_service_id"
  end

  create_table "facility_managers", force: :cascade do |t|
    t.integer "facility_id", null: false
    t.string "identify"
    t.string "name"
    t.string "email"
    t.integer "update_count"
    t.string "created_by"
    t.string "created_api_caller"
    t.string "updated_by"
    t.string "updated_api_caller"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.index ["email"], name: "index_facility_managers_on_email"
    t.index ["facility_id"], name: "index_facility_managers_on_facility_id"
  end

  create_table "fridge_latest_states", force: :cascade do |t|
    t.integer "fridge_id", null: false
    t.date "posted_at"
    t.decimal "current_storage_rate"
    t.integer "update_count"
    t.string "created_by"
    t.string "created_api_caller"
    t.string "updated_by"
    t.string "updated_api_caller"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fridge_id"], name: "index_fridge_latest_states_on_fridge_id"
  end

  create_table "fridge_past_states", force: :cascade do |t|
    t.integer "fridge_id", null: false
    t.date "posted_at"
    t.decimal "current_storage_rate"
    t.integer "update_count"
    t.string "created_by"
    t.string "created_api_caller"
    t.string "updated_by"
    t.string "updated_api_caller"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fridge_id"], name: "index_fridge_past_states_on_fridge_id"
  end

  create_table "fridges", force: :cascade do |t|
    t.integer "facility_id", null: false
    t.string "name"
    t.text "description"
    t.decimal "latitude"
    t.decimal "longitude"
    t.decimal "initial_storage_rate"
    t.integer "update_count"
    t.string "created_by"
    t.string "created_api_caller"
    t.string "updated_by"
    t.string "updated_api_caller"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["facility_id"], name: "index_fridges_on_facility_id"
  end

  create_table "service_managers", force: :cascade do |t|
    t.integer "service_id", null: false
    t.string "name"
    t.string "identify"
    t.integer "update_count"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.index ["service_id"], name: "index_service_managers_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "connection_phrase"
    t.text "description"
    t.integer "update_count"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "facilities", "services"
  add_foreign_key "facility_managers", "facilities"
  add_foreign_key "fridge_latest_states", "fridges"
  add_foreign_key "fridge_past_states", "fridges"
  add_foreign_key "fridges", "facilities"
  add_foreign_key "service_managers", "services"
end
