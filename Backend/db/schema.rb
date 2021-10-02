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

ActiveRecord::Schema.define(version: 2021_09_30_072432) do

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "escape_rooms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "startVertex"
    t.bigint "endVertex"
    t.string "name"
    t.bigint "user_id", default: 1, null: false
    t.index ["user_id"], name: "index_escape_rooms_on_user_id"
  end

  create_table "inventory_types", force: :cascade do |t|
    t.string "image_type", default: "container"
    t.bigint "blob_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "public_rooms", force: :cascade do |t|
    t.bigint "best_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "escape_room_id", null: false
    t.index ["escape_room_id"], name: "index_public_rooms_on_escape_room_id"
  end

  create_table "room_images", force: :cascade do |t|
    t.float "pos_x"
    t.float "pos_y"
    t.float "width"
    t.float "height"
    t.bigint "blob_id"
    t.bigint "escape_room_id", null: false
    t.index ["escape_room_id"], name: "index_room_images_on_escape_room_id"
  end

  create_table "room_ratings", force: :cascade do |t|
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "public_room_id", null: false
    t.index ["public_room_id"], name: "index_room_ratings_on_public_room_id"
    t.index ["user_id"], name: "index_room_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.boolean "is_admin"
    t.string "jwt_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "verified"
  end

  create_table "vertex_edges", id: false, force: :cascade do |t|
    t.bigint "from_vertex_id", null: false
    t.bigint "to_vertex_id", null: false
  end

  create_table "vertices", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.float "posx"
    t.float "posy"
    t.float "width"
    t.float "height"
    t.string "graphicid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.time "estimatedTime"
    t.string "description"
    t.string "clue"
    t.bigint "escape_room_id", default: 1, null: false
    t.bigint "blob_id"
    t.float "z_index"
    t.index ["escape_room_id"], name: "index_vertices_on_escape_room_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "escape_rooms", "users"
  add_foreign_key "public_rooms", "escape_rooms"
  add_foreign_key "room_images", "escape_rooms"
  add_foreign_key "room_ratings", "public_rooms"
  add_foreign_key "room_ratings", "users"
  add_foreign_key "vertices", "escape_rooms"
end
