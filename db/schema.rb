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

ActiveRecord::Schema.define(:version => 20140202145615) do

  create_table "charities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "check_ins", :force => true do |t|
    t.integer  "user_schedule_id"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "status"
    t.datetime "check_out_time"
  end

  add_index "check_ins", ["status"], :name => "index_check_ins_on_status"
  add_index "check_ins", ["user_id"], :name => "index_check_ins_on_user_id"
  add_index "check_ins", ["user_schedule_id"], :name => "index_check_ins_on_user_schedule_id"

  create_table "data_migrations", :id => false, :force => true do |t|
    t.string "version", :null => false
  end

  add_index "data_migrations", ["version"], :name => "unique_data_migrations", :unique => true

  create_table "days", :force => true do |t|
    t.integer  "mday"
    t.integer  "month"
    t.integer  "year"
    t.integer  "day_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "event_id"
    t.datetime "date"
  end

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

  create_table "department_assistants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "department_assistants", ["department_id"], :name => "index_department_assistants_on_department_id"
  add_index "department_assistants", ["user_id"], :name => "index_department_assistants_on_user_id"

  create_table "department_blocks", :force => true do |t|
    t.integer  "suggested_number_of_workers"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "department_id"
    t.text     "name"
    t.integer  "day_id"
    t.string   "start_time"
    t.string   "end_time"
  end

  add_index "department_blocks", ["day_id"], :name => "index_department_blocks_on_day_id"
  add_index "department_blocks", ["department_id"], :name => "index_department_blocks_on_department_id"

  create_table "department_managers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "department_managers", ["department_id"], :name => "index_department_managers_on_department_id"
  add_index "department_managers", ["user_id"], :name => "index_department_managers_on_user_id"

  create_table "departments", :force => true do |t|
    t.text     "name"
    t.integer  "budgeted_hours"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "email"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "assigned_to"
    t.integer  "route_type"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "other"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.date     "day_of_start"
    t.date     "day_of_finish"
    t.integer  "days_for_setup"
    t.integer  "days_for_tear_down"
    t.integer  "organisation_id"
  end

  create_table "flags", :force => true do |t|
    t.integer  "check_in_id"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "flags", ["check_in_id"], :name => "index_flags_on_check_in_id"
  add_index "flags", ["user_id"], :name => "index_flags_on_user_id"

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_availabilities", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "day_id"
    t.text     "start_time"
    t.text     "end_time"
  end

  add_index "user_availabilities", ["day_id"], :name => "index_user_availabilities_on_day_id"
  add_index "user_availabilities", ["user_id"], :name => "index_user_availabilities_on_user_id"

  create_table "user_charities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "charity_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_charities", ["charity_id"], :name => "index_user_charities_on_charity_id"
  add_index "user_charities", ["user_id"], :name => "index_user_charities_on_user_id"

  create_table "user_schedules", :force => true do |t|
    t.integer  "user_id"
    t.integer  "department_block_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "charity_id"
  end

  add_index "user_schedules", ["charity_id"], :name => "index_user_schedules_on_charity_id"
  add_index "user_schedules", ["department_block_id"], :name => "index_user_schedules_on_department_block_id"
  add_index "user_schedules", ["user_id"], :name => "index_user_schedules_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name",                             :null => false
    t.string   "last_name",                              :null => false
    t.string   "tshirt_size",                            :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "role"
    t.string   "cell_phone"
    t.string   "home_phone"
    t.text     "secondary_email"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name", "last_name"], :name => "index_users_on_first_name_and_last_name"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"

  create_table "volunteer_managers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "department_block_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "volunteer_managers", ["department_block_id"], :name => "index_volunteer_managers_on_department_block_id"
  add_index "volunteer_managers", ["user_id"], :name => "index_volunteer_managers_on_user_id"

end
