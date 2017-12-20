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

ActiveRecord::Schema.define(version: 20171220151005) do

  create_table "group_user_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.integer "authority", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_user_relations_on_group_id"
    t.index ["user_id"], name: "index_group_user_relations_on_user_id"
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "creator_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_groups_on_creator_id"
  end

  create_table "project_user_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.integer "authority", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_user_relations_on_project_id"
    t.index ["user_id"], name: "index_project_user_relations_on_user_id"
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "group_id", null: false
    t.bigint "creator_id", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_projects_on_creator_id"
    t.index ["group_id"], name: "index_projects_on_group_id"
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "group_id", null: false
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "priority", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_tasks_on_group_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "nickname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id", null: false
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_works_on_project_id"
    t.index ["task_id"], name: "index_works_on_task_id"
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "group_user_relations", "groups"
  add_foreign_key "group_user_relations", "users"
  add_foreign_key "groups", "users", column: "creator_id"
  add_foreign_key "project_user_relations", "projects"
  add_foreign_key "project_user_relations", "users"
  add_foreign_key "projects", "groups"
  add_foreign_key "projects", "users", column: "creator_id"
  add_foreign_key "tasks", "groups"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users"
  add_foreign_key "works", "projects"
  add_foreign_key "works", "tasks"
  add_foreign_key "works", "users"
end
