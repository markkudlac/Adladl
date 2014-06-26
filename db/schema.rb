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

ActiveRecord::Schema.define(version: 20140625173830) do

  create_table "ad_lists", force: true do |t|
    t.integer  "device_id",  null: false
    t.integer  "advert_id",  null: false
    t.integer  "action",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_lists", ["advert_id"], name: "index_ad_lists_on_advert_id"
  add_index "ad_lists", ["device_id", "advert_id"], name: "index_ad_lists_on_device_id_and_advert_id", unique: true
  add_index "ad_lists", ["device_id"], name: "index_ad_lists_on_device_id"

  create_table "admins", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "adverts", force: true do |t|
    t.integer  "group",                    default: 0
    t.string   "adtype",        limit: 2,  default: "AD", null: false
    t.string   "urlimg",                                  null: false
    t.string   "urlhref"
    t.string   "descript",      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon"
    t.string   "icon_image"
    t.string   "icon_filename", limit: 40
    t.string   "ad_image"
    t.string   "ad_filename",   limit: 40
    t.integer  "client_id"
  end

  add_index "adverts", ["client_id"], name: "index_adverts_on_client_id"
  add_index "adverts", ["group"], name: "index_adverts_on_group"

  create_table "clients", force: true do |t|
    t.integer  "admin_id",              null: false
    t.string   "apikey",     limit: 10, null: false
    t.string   "company",    limit: 70
    t.string   "firstname",  limit: 40
    t.string   "surname",    limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["admin_id"], name: "index_clients_on_admin_id", unique: true
  add_index "clients", ["apikey"], name: "index_clients_on_apikey", unique: true

  create_table "devices", force: true do |t|
    t.string   "tag",          limit: 30,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "instruct_cnt",            default: 0
  end

  add_index "devices", ["tag"], name: "index_devices_on_tag", unique: true

end
