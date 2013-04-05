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

ActiveRecord::Schema.define(:version => 20130325225629) do

  create_table "entities", :force => true do |t|
    t.string   "fips_code",        :limit => 4
    t.string   "entity_name",      :limit => 40
    t.string   "entity_type",      :limit => 20
    t.integer  "entity_parent_id"
    t.string   "lasd",             :limit => 4
    t.string   "lasd_translation", :limit => 50
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "geojson_cache",    :limit => 2147483647
  end

  create_table "entity_boundaries", :force => true do |t|
    t.integer  "entity_id"
    t.boolean  "starting_point"
    t.decimal  "lat",            :precision => 18, :scale => 12
    t.decimal  "lng",            :precision => 18, :scale => 12
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

end
