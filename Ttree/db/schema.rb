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

ActiveRecord::Schema.define(version: 20161022090040) do

  create_table "branches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
    t.boolean  "viewstate"
    t.index ["ancestry"], name: "index_branches_on_ancestry", using: :btree
    t.index ["work_id", "created_at"], name: "index_branches_on_work_id_and_created_at", using: :btree
    t.index ["work_id"], name: "index_branches_on_work_id", using: :btree
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "title",      limit: 65535
    t.text     "url",        limit: 65535
    t.integer  "branch_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["branch_id", "created_at"], name: "index_pages_on_branch_id_and_created_at", using: :btree
    t.index ["branch_id"], name: "index_pages_on_branch_id", using: :btree
  end

  create_table "search_suggestions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "starlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_starlists_on_user_id", using: :btree
    t.index ["work_id", "user_id"], name: "index_starlists_on_work_id_and_user_id", unique: true, using: :btree
    t.index ["work_id"], name: "index_starlists_on_work_id", using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclassifiedpages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "title",      limit: 65535
    t.text     "url",        limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "timenum"
    t.index ["user_id", "created_at"], name: "index_unclassifiedpages_on_user_id_and_created_at", using: :btree
    t.index ["user_id"], name: "index_unclassifiedpages_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "ut_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "member_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id", "team_id"], name: "index_ut_relationships_on_member_id_and_team_id", unique: true, using: :btree
    t.index ["member_id"], name: "index_ut_relationships_on_member_id", using: :btree
    t.index ["team_id"], name: "index_ut_relationships_on_team_id", using: :btree
  end

  create_table "works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "viewwidth"
    t.integer  "first_branch"
    t.index ["team_id", "created_at"], name: "index_works_on_team_id_and_created_at", using: :btree
    t.index ["user_id", "created_at"], name: "index_works_on_user_id_and_created_at", using: :btree
  end

  add_foreign_key "branches", "works"
  add_foreign_key "unclassifiedpages", "users"
end
