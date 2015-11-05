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

ActiveRecord::Schema.define(version: 20151105033000) do

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "work_id"
    t.integer  "likes_count", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "comments_likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments_likes", ["user_id", "comment_id"], name: "index_comments_likes_on_user_id_and_comment_id", unique: true

  create_table "favorite_folders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "favorites_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "favorite_folder_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "thanks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "thanks", ["work_id", "user_id"], name: "index_thanks_on_work_id_and_user_id", unique: true

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
    t.string   "nickname"
    t.string   "location"
    t.string   "title"
    t.string   "company"
    t.integer  "sex"
    t.string   "avatar"
    t.integer  "fans_count",             default: 0
    t.string   "bio"
    t.string   "website"
    t.integer  "likes_count",            default: 0
    t.integer  "thanks_count",           default: 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "visit_tracks", force: :cascade do |t|
    t.string   "visit_path"
    t.datetime "visit_time"
    t.string   "ip"
    t.integer  "user_id"
    t.integer  "visit_count", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "visit_tracks", ["ip"], name: "index_visit_tracks_on_ip"
  add_index "visit_tracks", ["visit_path"], name: "index_visit_tracks_on_visit_path"

  create_table "works", force: :cascade do |t|
    t.string   "title"
    t.string   "image"
    t.text     "desciption"
    t.integer  "user_id"
    t.integer  "views_count",        default: 0
    t.integer  "works_likes_count",  default: 0
    t.integer  "favorites_count",    default: 0
    t.integer  "shares_count",       default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "thanks_count",       default: 0
    t.boolean  "is_original",        default: false
    t.string   "work_type",          default: "new"
    t.integer  "parent_work_id"
  end

  add_index "works", ["user_id", "created_at"], name: "index_works_on_user_id_and_created_at"

  create_table "works_likes", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "works_likes", ["work_id", "user_id"], name: "index_works_likes_on_work_id_and_user_id", unique: true

end
