# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101124080944) do

  create_table "experiments", :force => true do |t|
    t.string   "name"
    t.boolean  "done"
    t.string   "proces"
    t.string   "max_kandydatow"
    t.string   "iteracji_alg_h"
    t.string   "iteracji_planow_sasiednich"
    t.string   "waga_cost"
    t.string   "waga_availability"
    t.string   "waga_succesful"
    t.string   "ograniczenie_cost"
    t.string   "ograniczenie_availability"
    t.string   "ograniczenie_succesful"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "result"
    t.text     "csv"
    t.string   "algorytm_doboru_uslug"
    t.string   "waga_time"
    t.string   "ograniczenie_time"
    t.float    "podobienstwo"
    t.text     "ocena_bezpieczenstwa"
  end

  create_table "parameters", :force => true do |t|
    t.integer  "settings_id"
    t.string   "name"
    t.string   "value"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sla_experiments", :force => true do |t|
    t.integer  "experiment_id"
    t.integer  "sla_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sla_experiments", ["experiment_id"], :name => "index_sla_experiments_on_experiment_id"
  add_index "sla_experiments", ["sla_id"], :name => "index_sla_experiments_on_sla_id"

  create_table "slas", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
