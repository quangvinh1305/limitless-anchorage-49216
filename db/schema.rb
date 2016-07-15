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

ActiveRecord::Schema.define(version: 20160714012613) do

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "cart_id",    limit: 4
    t.integer  "quantity",   limit: 4,                default: 1
    t.integer  "order_id",   limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.decimal  "price",                precision: 10
  end

  create_table "microposts", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "picture",    limit: 255
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree
  add_index "microposts", ["user_id"], name: "index_microposts_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "address",      limit: 65535
    t.string   "email",        limit: 255
    t.string   "pay_type",     limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "phone_number", limit: 255
    t.integer  "user_id",      limit: 4
    t.integer  "status",       limit: 4,     default: 0
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "image",       limit: 255
    t.decimal  "price",                     precision: 8, scale: 2
    t.string   "pin",         limit: 255
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "stock",       limit: 4,                             default: 0
    t.integer  "category_id", limit: 4
    t.integer  "user_id",     limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.string   "password_digest",   limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "remember_digest",   limit: 255
    t.boolean  "admin",                         default: false
    t.string   "reset_digest",      limit: 255
    t.string   "activation_digest", limit: 255
    t.boolean  "activated",                     default: false
    t.datetime "activated_at"
    t.datetime "reset_sent_at"
    t.string   "address",           limit: 255
    t.string   "phone_number",      limit: 255
  end

  add_foreign_key "microposts", "users"
end
