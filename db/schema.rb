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

ActiveRecord::Schema.define(version: 2021_12_13_172127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_clients", id: :serial, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "calls_count", default: 0, null: false
    t.string "app_id", null: false
    t.string "app_secret", null: false
    t.string "origin", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calls_count_tracings", id: :serial, force: :cascade do |t|
    t.integer "api_client_id"
    t.integer "calls_count", null: false
    t.datetime "at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_calls_count_tracings_on_api_client_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.integer "users_id"
    t.integer "remote_id"
    t.string "name"
    t.text "description"
    t.string "tags", array: true
    t.string "machines", array: true
    t.string "components", array: true
    t.string "themes", array: true
    t.string "author"
    t.string "collaborators", array: true
    t.string "steps_body"
    t.string "image_path"
    t.string "project_path"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_id"], name: "index_projects_on_users_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "calls_count_tracings", "api_clients"
  add_foreign_key "projects", "users", column: "users_id"
end
