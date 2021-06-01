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

ActiveRecord::Schema.define(version: 2021_06_01_132244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "nextV"
    t.time "estimatedTime"
    t.string "description"
    t.string "clue"
  end

end
