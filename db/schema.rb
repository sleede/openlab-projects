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

ActiveRecord::Schema.define(version: 2022_02_24_152030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

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
    t.integer "api_client_id"
    t.integer "project_id"
    t.string "name"
    t.text "description"
    t.text "tags"
    t.string "machines", array: true
    t.string "components", array: true
    t.string "themes", array: true
    t.string "author"
    t.string "collaborators", array: true
    t.text "steps_body"
    t.string "image_path"
    t.string "project_path"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.tsvector "search_vector"
    t.index ["api_client_id"], name: "index_projects_on_api_client_id"
    t.index ["search_vector"], name: "index_projects_on_search_vector", using: :gin
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
  add_foreign_key "projects", "api_clients"
end
