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

ActiveRecord::Schema.define(:version => 20130424113732) do

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

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "feed_url"
    t.string   "url"
    t.string   "description"
    t.string   "generator"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "last_fetched"
    t.string   "favicon_url"
  end

  create_table "layers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "icon_url"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.decimal  "lat"
    t.decimal  "lon"
    t.integer  "feed_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "guid"
    t.datetime "published"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "layer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_url"
    t.integer  "icon_size",  :default => 12
  end

  add_index "subscriptions", ["feed_id", "layer_id"], :name => "index_feeds_layers_on_feed_id_and_layer_id", :unique => true
  add_index "subscriptions", ["id"], :name => "id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
