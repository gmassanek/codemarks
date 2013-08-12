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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130812035015) do

  create_table "authentications", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.string   "image"
    t.string   "description"
    t.string   "nickname"
  end

  create_table "clicks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "resource_type"
  end

  create_table "codemark_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "description"
    t.text     "title"
    t.tsvector "search"
    t.boolean  "private",       :default => false
    t.string   "resource_type"
  end

  add_index "codemark_records", ["search"], :name => "codemarks_search_index"

  create_table "codemark_topics", :force => true do |t|
    t.integer  "codemark_record_id"
    t.integer  "topic_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "codemark_id"
    t.integer  "author_id"
    t.text     "text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "links", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "private",         :default => false
    t.integer  "clicks_count",    :default => 0
    t.integer  "codemarks_count", :default => 0
    t.string   "host"
    t.text     "site_data"
    t.integer  "author_id"
    t.string   "snapshot_url"
    t.string   "snapshot_id"
  end

  add_index "links", ["url"], :name => "index_link_records_on_url"

  create_table "text_records", :force => true do |t|
    t.text     "text"
    t.string   "title"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "author_id"
    t.integer  "clicks_count", :default => 0
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.string   "slug"
    t.tsvector "search"
  end

  add_index "topics", ["slug"], :name => "index_topics_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
    t.string   "location"
    t.string   "image"
    t.string   "description"
    t.string   "nickname"
    t.string   "slug"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
