# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160525072132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_key"
    t.datetime "expiry"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "active",      default: false
  end

  add_index "sessions", ["session_key", "created_at"], name: "index_sessions_on_session_key_and_created_at", unique: true, using: :btree
  add_index "sessions", ["session_key", "expiry"], name: "index_sessions_on_session_key_and_expiry", unique: true, using: :btree
  add_index "sessions", ["user_id", "session_key", "active"], name: "index_sessions_on_user_id_and_session_key_and_active", using: :btree
  add_index "sessions", ["user_id", "session_key", "expiry"], name: "index_sessions_on_user_id_and_session_key_and_expiry", using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "trace_logs", force: :cascade do |t|
    t.datetime "log_time",    default: "now()"
    t.integer  "user_id"
    t.integer  "rrn"
    t.text     "description"
  end

  add_index "trace_logs", ["log_time"], name: "index_trace_logs_on_log_time", using: :btree
  add_index "trace_logs", ["rrn"], name: "index_trace_logs_on_rrn", using: :btree
  add_index "trace_logs", ["user_id"], name: "index_trace_logs_on_user_id", using: :btree

  create_table "user_identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "password_hash"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_identities", ["user_id"], name: "index_user_identities_on_user_id", using: :btree
  add_index "user_identities", ["username"], name: "index_user_identities_on_username", unique: true, using: :btree

  create_table "usernames", id: false, force: :cascade do |t|
    t.integer  "year",       null: false
    t.integer  "seq",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "usernames", ["year", "seq"], name: "index_usernames_on_year_and_seq", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "mid_name"
    t.string   "last_name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "status",           default: 0
    t.string   "email"
    t.date     "birthday"
    t.string   "cellphone_number"
    t.string   "telephone_number"
    t.string   "address"
    t.binary   "photo"
    t.date     "date_start"
    t.integer  "gender",           default: 0
    t.string   "token"
    t.datetime "token_expiry"
    t.integer  "user_type",        default: 0
    t.string   "username"
  end

  add_index "users", ["token"], name: "index_users_on_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "sessions", "users"
  add_foreign_key "user_identities", "users"
end
