# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160905044345) do

  create_table "children", force: :cascade do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.date     "birthdate"
    t.integer  "diapers_inventory"
    t.integer  "bully_rating",      default: 0
    t.integer  "ouch_rating",       default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "daily_reports", force: :cascade do |t|
    t.date     "date"
    t.integer  "poopy_diapers"
    t.integer  "wet_diapers"
    t.text     "bullying_report"
    t.text     "ouch_report"
    t.integer  "child_id"
    t.boolean  "bullying_incident"
    t.boolean  "ouch_incident"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "kind_acts", force: :cascade do |t|
    t.text     "act"
    t.integer  "daily_report_id"
    t.integer  "recipient_id"
    t.integer  "giver_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end