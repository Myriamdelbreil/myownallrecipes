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

ActiveRecord::Schema[7.1].define(version: 2026_04_10_081643) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
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

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "image_url"
    t.index "lower((name)::text) gin_trgm_ops", name: "index_categories_on_lower_name_trgm", using: :gin
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text) gin_trgm_ops", name: "index_ingredients_on_lower_name_trgm", using: :gin
    t.index "to_tsvector('simple'::regconfig, (name)::text)", name: "index_ingredients_on_name_tsearch", using: :gin
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.float "quantity"
    t.string "unit"
    t.string "original_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title", null: false
    t.integer "cook_time", default: 0, null: false
    t.integer "prep_time", default: 0, null: false
    t.float "ratings"
    t.string "cuisine"
    t.string "image_url"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.index "to_tsvector('simple'::regconfig, (title)::text)", name: "index_recipes_on_title_tsearch", using: :gin
    t.index ["category_id"], name: "index_recipes_on_category_id"
    t.index ["slug"], name: "index_recipes_on_slug", unique: true
    t.check_constraint "cook_time >= 0", name: "check_cook_time_non_negative"
    t.check_constraint "prep_time >= 0", name: "check_prep_time_non_negative"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "categories"
end
