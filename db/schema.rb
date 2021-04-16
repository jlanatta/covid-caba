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

ActiveRecord::Schema.define(version: 2021_04_16_125728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stat_subtypes", force: :cascade do |t|
    t.string "key"
    t.bigint "stat_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stat_type_id"], name: "index_stat_subtypes_on_stat_type_id"
  end

  create_table "stat_types", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stats", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "stat_subtype_id", null: false
    t.float "value", null: false
    t.date "process_date"
    t.integer "process_identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stat_subtype_id"], name: "index_stats_on_stat_subtype_id"
  end

  add_foreign_key "stat_subtypes", "stat_types"
  add_foreign_key "stats", "stat_subtypes"
end
