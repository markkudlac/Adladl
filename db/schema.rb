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

ActiveRecord::Schema.define(version: 20140507191100) do

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

  create_table "adverts", force: true do |t|
    t.integer  "group",                 default: 0
    t.string   "adtype",     limit: 2,  default: "AD", null: false
    t.string   "urlimg",                               null: false
    t.string   "urlhref"
    t.string   "descript",   limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adverts", ["group"], name: "index_adverts_on_group"

  create_table "devices", force: true do |t|
    t.string   "tag",        limit: 30, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["tag"], name: "index_devices_on_tag", unique: true

end
