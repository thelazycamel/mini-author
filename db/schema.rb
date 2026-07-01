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

ActiveRecord::Schema[7.2].define(version: 2026_07_01_144015) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "learning_objects", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "name", limit: 255, null: false
    t.string "lo"
    t.string "upload_response"
    t.string "info_xml"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_learning_objects_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "domain", limit: 255, null: false
    t.string "path", limit: 255
    t.string "port", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "structure_path"
    t.string "callback_base_url"
    t.string "api_token"
  end

  create_table "structures", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "name", limit: 255, null: false
    t.string "structure_xml"
    t.string "upload_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "course_id"
    t.string "cover_image_url"
    t.index ["site_id"], name: "index_structures_on_site_id"
  end

  add_foreign_key "learning_objects", "sites"
  add_foreign_key "structures", "sites"
end
