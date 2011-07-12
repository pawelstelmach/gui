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

ActiveRecord::Schema.define(:version => 20110702093054) do

  create_table "atomic_engine_services", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "method"
    t.string   "service_class"
    t.string   "inputs"
    t.string   "outputs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engines", :force => true do |t|
    t.integer  "user_id"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "user_id"
    t.datetime "last_used"
    t.integer  "execution_number"
  end

  create_table "mediators", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "username"
    t.string   "password"
  end

  create_table "parameters", :force => true do |t|
    t.integer  "settings_id"
    t.string   "name"
    t.string   "value"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "response_times", :force => true do |t|
    t.float    "response_time"
    t.integer  "mediator_id"
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
    t.integer  "user_id"
  end

  create_table "smart_engine_services", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         :default => 0
    t.integer  "failed_login_count",  :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "engine_name"
    t.text     "engine_settings"
  end

end
