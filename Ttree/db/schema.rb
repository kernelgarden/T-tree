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

ActiveRecord::Schema.define(version: 20160907044211) do

  create_table "branches", force: :cascade do |t|
    t.string   "name"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
    t.index ["ancestry"], name: "index_branches_on_ancestry"
    t.index ["work_id", "created_at"], name: "index_branches_on_work_id_and_created_at"
    t.index ["work_id"], name: "index_branches_on_work_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "url"
    t.integer  "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id", "created_at"], name: "index_pages_on_branch_id_and_created_at"
    t.index ["branch_id"], name: "index_pages_on_branch_id"
  end

  create_table "starlists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_starlists_on_user_id"
    t.index ["work_id", "user_id"], name: "index_starlists_on_work_id_and_user_id", unique: true
    t.index ["work_id"], name: "index_starlists_on_work_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclassifiedpages", force: :cascade do |t|
    t.string   "title"
    t.text     "url"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_unclassifiedpages_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_unclassifiedpages_on_user_id"
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
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "ut_relationships", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id", "team_id"], name: "index_ut_relationships_on_member_id_and_team_id", unique: true
    t.index ["member_id"], name: "index_ut_relationships_on_member_id"
    t.index ["team_id"], name: "index_ut_relationships_on_team_id"
  end

  create_table "works", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "created_at"], name: "index_works_on_team_id_and_created_at"
    t.index ["user_id", "created_at"], name: "index_works_on_user_id_and_created_at"
  end

end
