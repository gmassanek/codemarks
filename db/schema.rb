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

ActiveRecord::Schema.define(version: 20150329035818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid",         limit: 255
    t.string   "provider",    limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.string   "location",    limit: 255
    t.string   "image",       limit: 255
    t.string   "description", limit: 255
    t.string   "nickname",    limit: 255
  end

  add_index "authentications", ["uid", "provider"], name: "index_authentications_on_uid_and_provider", using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "clicks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_type", limit: 255
  end

  add_index "clicks", ["resource_id", "resource_type"], name: "index_clicks_on_resource_id_and_resource_type", using: :btree
  add_index "clicks", ["user_id"], name: "index_clicks_on_user_id", using: :btree

  create_table "codemarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "title"
    t.tsvector "search"
    t.boolean  "private",                   default: false
    t.string   "resource_type", limit: 255
    t.integer  "group_id"
    t.text     "source"
  end

  add_index "codemarks", ["created_at"], name: "index_codemarks_on_created_at", using: :btree
  add_index "codemarks", ["group_id"], name: "index_codemarks_on_group_id", using: :btree
  add_index "codemarks", ["resource_id", "created_at"], name: "index_codemarks_on_resource_id_and_created_at", using: :btree
  add_index "codemarks", ["resource_id", "resource_type"], name: "index_codemarks_on_resource_id_and_resource_type", using: :btree
  add_index "codemarks", ["resource_id"], name: "index_codemarks_on_resource_id", using: :btree
  add_index "codemarks", ["resource_type"], name: "index_codemarks_on_resource_type", using: :btree
  add_index "codemarks", ["search"], name: "codemarks_search_index", using: :gin
  add_index "codemarks", ["user_id"], name: "index_codemarks_on_user_id", using: :btree

  create_table "codemarks_topics", force: :cascade do |t|
    t.integer "codemark_id"
    t.integer "topic_id"
  end

  add_index "codemarks_topics", ["codemark_id"], name: "index_codemarks_topics_on_codemark_id", using: :btree
  add_index "codemarks_topics", ["topic_id"], name: "index_codemarks_topics_on_topic_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",               default: 0
    t.string   "commentable_type", limit: 255
    t.string   "title",            limit: 255
    t.text     "body"
    t.string   "subject",          limit: 255
    t.integer  "user_id",                      default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["lft"], name: "index_comments_on_lft", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["rgt"], name: "index_comments_on_rgt", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "groups_users", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "clicks_count",                   default: 0
    t.integer  "codemarks_count",                default: 0
    t.string   "type",               limit: 255
    t.hstore   "properties"
    t.hstore   "indexed_properties"
    t.tsvector "search"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "resources", ["author_id"], name: "index_resources_on_author_id", using: :btree
  add_index "resources", ["clicks_count"], name: "index_resources_on_clicks_count", using: :btree
  add_index "resources", ["codemarks_count"], name: "index_resources_on_codemarks_count", using: :btree
  add_index "resources", ["created_at"], name: "index_resources_on_created_at", using: :btree
  add_index "resources", ["indexed_properties"], name: "resources_indexed_properties", using: :gin
  add_index "resources", ["search"], name: "resources_search_index", using: :gin
  add_index "resources", ["type"], name: "index_resources_on_type", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "slug",        limit: 255
    t.tsvector "search"
    t.integer  "group_id"
  end

  add_index "topics", ["group_id"], name: "index_topics_on_group_id", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree
  add_index "topics", ["title"], name: "index_topics_on_title", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.string   "location",    limit: 255
    t.string   "image",       limit: 255
    t.text     "description"
    t.string   "nickname",    limit: 255
    t.string   "slug",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
