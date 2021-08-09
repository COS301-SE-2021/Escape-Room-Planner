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

ActiveRecord::Schema.define(version: 2021_07_06_132139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "escape_rooms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "startVertex"
    t.bigint "endVertex"
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.boolean "is_admin"
    t.string "jwt_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["escape_room_id"], name: "index_vertices_on_escape_room_id"
  end

  add_foreign_key "vertices", "escape_rooms"
end
