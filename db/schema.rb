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

ActiveRecord::Schema.define(version: 20170723011424) do

  create_table "annnotis", force: :cascade do |t|
    t.integer  "notification_type"
    t.integer  "announcement_id"
    t.integer  "group_id"
    t.integer  "sender"
    t.integer  "receiver"
    t.string   "title"
    t.binary   "content"
    t.boolean  "read",              default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "title"
    t.binary   "content"
    t.string   "email"
    t.integer  "sender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "budgets", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "group_budget"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "calnotis", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "group_id"
    t.integer  "sender"
    t.integer  "receiver"
    t.string   "title"
    t.string   "description"
    t.datetime "start"
    t.datetime "end"
    t.boolean  "read",        default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "calendar_type"
    t.integer  "event_type"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "start"
    t.datetime "end"
    t.string   "color",         default: "black"
    t.string   "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "eventusers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "color",      default: "blue"
    t.boolean  "admin",      default: false
    t.boolean  "sync",       default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "groupfiles", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "file_url"
    t.string   "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "school"
    t.string   "password"
    t.string   "description"
    t.string   "email"
    t.string   "website_address"
    t.string   "image_url",       default: "http://www.niagaracollege.ca/alumni-relations/wp-content/uploads/sites/25/2015/05/Icon-Group.svg"
    t.datetime "created_at",                                                                                                                   null: false
    t.datetime "updated_at",                                                                                                                   null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "options", force: :cascade do |t|
    t.integer  "poll_id"
    t.string   "content"
    t.integer  "vote_number", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "pollnotis", force: :cascade do |t|
    t.integer  "notification_type"
    t.integer  "group_id"
    t.integer  "poll_id"
    t.integer  "sender"
    t.integer  "receiver"
    t.string   "title"
    t.boolean  "read",              default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "polls", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "title"
    t.boolean  "anonymous",  default: false
    t.integer  "sender"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "pollusers", force: :cascade do |t|
    t.integer  "poll_id"
    t.integer  "user_id"
    t.integer  "option_id"
    t.boolean  "voted",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "value"
    t.string   "description", default: "No Description"
    t.integer  "budget_id"
    t.boolean  "pos_neg",     default: true
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                                                                                             null: false
    t.string   "encrypted_password",     default: "",                                                                                             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                                                                                              null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                                                                      null: false
    t.datetime "updated_at",                                                                                                                      null: false
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "school"
    t.integer  "class_year"
    t.string   "major"
    t.string   "image_url",              default: "https://lh4.googleusercontent.com/-jSJrMg5AJqY/AAAAAAAAAAI/AAAAAAAAAQU/6Ps1RMLKfQE/photo.jpg"
    t.string   "index_first_time",       default: "yes"
    t.string   "group_first_time",       default: "yes"
    t.string   "mycalendar_first_time",  default: "yes"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
