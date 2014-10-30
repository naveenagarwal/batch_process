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

ActiveRecord::Schema.define(version: 20141029085001) do

  create_table "batch_process", force: true do |t|
    t.integer  "product_id"
    t.integer  "mortar_id"
    t.integer  "width"
    t.integer  "height"
    t.integer  "scale"
    t.integer  "coursing"
    t.integer  "Stagger"
    t.string   "output"
    t.string   "status"
    t.datetime "created_at"
  end

  create_table "batch_processes", force: true do |t|
    t.string   "name"
    t.integer  "status",      default: 0
    t.integer  "failed"
    t.integer  "completed"
    t.integer  "successfull"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", force: true do |t|
    t.string  "name",                limit: 50,                null: false
    t.string  "image_path",                                    null: false
    t.string  "original_image_name"
    t.boolean "is_active",                      default: true
    t.integer "created_by",                                    null: false
    t.integer "created_at",                                    null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "design_images", force: true do |t|
    t.text    "html",       limit: 16777215
    t.integer "image_name"
    t.string  "image_type", limit: 30
    t.string  "user_ip",    limit: 30
    t.string  "user_agent"
    t.integer "created_by",                  null: false
    t.integer "created_at",                  null: false
  end

  create_table "image_data", force: true do |t|
    t.integer  "scale"
    t.integer  "width"
    t.integer  "height"
    t.integer  "mortar"
    t.integer  "material"
    t.string   "output"
    t.integer  "batch_process_id"
    t.integer  "stagger"
    t.integer  "coursing"
    t.integer  "status",           default: 0
    t.string   "output_path"
    t.string   "message"
    t.text     "backtrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_data", ["batch_process_id"], name: "index_image_data_on_batch_process_id", using: :btree

  create_table "log_history", force: true do |t|
    t.integer "log_type_id", limit: 1,   null: false
    t.text    "details",     limit: 255, null: false
    t.integer "created_by",              null: false
    t.integer "create_date",             null: false
    t.string  "IP",          limit: 15,  null: false
    t.string  "user_agent"
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "log_types", force: true do |t|
    t.string  "name",        limit: 100,             null: false
    t.string  "details"
    t.integer "is_active",   limit: 1,   default: 1
    t.integer "created_by",                          null: false
    t.integer "created_at",                          null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "manufacturer_types", force: true do |t|
    t.string  "name",        limit: 100,                null: false
    t.boolean "is_active",               default: true, null: false
    t.integer "created_by",                             null: false
    t.integer "created_at",                             null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "manufacturers", force: true do |t|
    t.string  "company",             limit: 100,                null: false
    t.string  "name",                limit: 50,                 null: false
    t.string  "address",                                        null: false
    t.string  "contact_number",      limit: 50,                 null: false
    t.string  "email_id",            limit: 50,                 null: false
    t.string  "image_path",                                     null: false
    t.string  "original_image_name"
    t.boolean "type",                            default: true
    t.boolean "is_active",                       default: true
    t.integer "created_by",                                     null: false
    t.integer "created_at",                                     null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "menus", force: true do |t|
    t.boolean "menu_usage",                 default: true, null: false
    t.string  "menu_code",                                 null: false
    t.string  "menu_name",                                 null: false
    t.integer "is_active",        limit: 1, default: 1
    t.integer "parent_menu_id",             default: 0,    null: false
    t.integer "menu_type",        limit: 1,                null: false
    t.string  "menu_url",                   default: "#",  null: false
    t.integer "menu_order",       limit: 1
    t.string  "menu_description"
    t.string  "menu_image_path"
    t.integer "created_by",                 default: 0
    t.integer "created_at",                 default: 0
    t.integer "modified_by",                default: 0
    t.integer "modified_at",                default: 0
  end

  add_index "menus", ["menu_code"], name: "menu_code", using: :btree

  create_table "mortar_colors", force: true do |t|
    t.string   "name",                limit: 100,                null: false
    t.string   "rgba_value",          limit: 50,                 null: false
    t.string   "image_name",                                     null: false
    t.string   "original_image_name"
    t.boolean  "is_active",                       default: true
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "modified_by"
    t.datetime "modified_at"
  end

  create_table "mortars", force: true do |t|
    t.string  "name",                                                       null: false
    t.string  "rgba_value",                  limit: 20, default: "0,0,0,0", null: false
    t.integer "fuzz",                                   default: 5
    t.integer "manufacturer_id",                                            null: false
    t.integer "size_id",                                                    null: false
    t.string  "image_path",                                                 null: false
    t.string  "variant_image",                                              null: false
    t.string  "original_image_name"
    t.string  "original_variant_image_name"
    t.boolean "is_active",                              default: true
    t.integer "created_by",                                                 null: false
    t.integer "created_at",                                                 null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "plants", force: true do |t|
    t.integer "manufacturer_id",                                null: false
    t.string  "name",                limit: 100,                null: false
    t.string  "image_path"
    t.string  "original_image_name"
    t.string  "plant_longitude",     limit: 20
    t.string  "plant_latitude",      limit: 20
    t.boolean "is_active",                       default: true
    t.integer "created_by",                                     null: false
    t.integer "created_at",                                     null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  add_index "plants", ["manufacturer_id"], name: "manufacturer_fk", using: :btree

  create_table "product_details", force: true do |t|
    t.integer "product_id",                                                                      null: false
    t.string  "leed_distance"
    t.string  "recommended_cleaning",           limit: 100
    t.string  "astm_type",                      limit: 50
    t.string  "master_format_2010",             limit: 100
    t.string  "astm_specification",             limit: 30
    t.date    "test_date"
    t.integer "efflorescence",                  limit: 1,                            default: 0, null: false
    t.string  "percent_void",                   limit: 10
    t.string  "min_thickness_of_face_shells",   limit: 10
    t.string  "equivalent_web_thickness",       limit: 10
    t.decimal "recycled_content_percent",                   precision: 10, scale: 1
    t.decimal "qty_per_sf",                                 precision: 10, scale: 1
    t.string  "product_water_absorption_types"
    t.decimal "weight_pounds",                              precision: 10, scale: 1
    t.string  "compressive_strength_psi",       limit: 20
    t.string  "specifications"
    t.integer "created_by",                                                                      null: false
    t.integer "created_at",                                                                      null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  add_index "product_details", ["product_id"], name: "product_fk", using: :btree

  create_table "product_images", force: true do |t|
    t.integer "product_id",                              null: false
    t.string  "image_initial_text",                      null: false
    t.string  "logo_image",                  limit: 100
    t.string  "variant_image",               limit: 100
    t.string  "original_image_name"
    t.string  "original_variant_image_name"
    t.integer "created_by",                              null: false
    t.integer "created_at",                              null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "product_references", force: true do |t|
    t.integer "manufacturer_id",                 null: false
    t.integer "size_id",                         null: false
    t.integer "plant_id",                        null: false
    t.integer "texture_id",                      null: false
    t.integer "color_id",                        null: false
    t.integer "product_id",                      null: false
    t.boolean "has_image",       default: false
    t.integer "created_by",                      null: false
    t.integer "created_at",                      null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "products", force: true do |t|
    t.string  "name",                                     null: false
    t.string  "product_number", limit: 50,                null: false
    t.string  "description"
    t.string  "catalog"
    t.string  "image_path"
    t.boolean "is_active",                 default: true
    t.integer "created_by",                               null: false
    t.integer "created_at",                               null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "role_permissions", force: true do |t|
    t.integer "role_id",     null: false
    t.string  "menu_codes",  null: false
    t.integer "created_by",  null: false
    t.integer "created_at",  null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "roles", force: true do |t|
    t.string  "role_name",   limit: 100,             null: false
    t.string  "role_code",   limit: 50,              null: false
    t.integer "is_deleted",  limit: 1,   default: 0
    t.integer "is_active",   limit: 1,   default: 1
    t.integer "created_by",                          null: false
    t.integer "created_at"
    t.integer "modified_by",                         null: false
    t.integer "modified_at"
  end

  add_index "roles", ["role_code"], name: "role_code", unique: true, using: :btree

  create_table "site_configurations", id: false, force: true do |t|
    t.string  "site_name",                                  null: false
    t.string  "site_email",         limit: 100,             null: false
    t.integer "site_status",        limit: 1,   default: 1, null: false
    t.string  "offline_message"
    t.string  "site_logo_path",     limit: 120,             null: false
    t.string  "fb_app_id",          limit: 50,              null: false
    t.string  "fb_app_secret",      limit: 75,              null: false
    t.string  "fb_return_url",                              null: false
    t.string  "twitter_api_key",    limit: 100,             null: false
    t.string  "twitter_api_secret", limit: 100,             null: false
    t.string  "twitter_owner",                              null: false
    t.string  "twitter_owner_id",   limit: 50,              null: false
    t.integer "created_by",                                 null: false
    t.integer "created_at",                                 null: false
    t.integer "modified_by",                                null: false
    t.integer "modified_at",                                null: false
  end

  create_table "site_translation", id: false, force: true do |t|
    t.integer "id",                                        null: false
    t.string  "lang_code",        limit: 2,                null: false
    t.string  "source_label",                              null: false
    t.string  "translated_label"
    t.integer "created_by"
    t.integer "created_at"
    t.integer "modified_by"
    t.integer "modified_at"
    t.boolean "is_active",                  default: true
  end

  create_table "sizes", force: true do |t|
    t.string  "name",                limit: 100,                         null: false
    t.string  "image_path",                      default: "default.jpg", null: false
    t.string  "original_image_name"
    t.float   "width",               limit: 24,                          null: false
    t.float   "height",              limit: 24,                          null: false
    t.float   "depth",               limit: 24,                          null: false
    t.string  "dimension_unit",      limit: 20,                          null: false
    t.boolean "is_active",                       default: true
    t.integer "created_by",                                              null: false
    t.integer "created_at",                                              null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "system_logs", force: true do |t|
    t.string  "IP",                  limit: 15,  null: false
    t.string  "user_agent",                      null: false
    t.boolean "operation_performed",             null: false
    t.string  "module_name",                     null: false
    t.text    "id_range",            limit: 255
    t.integer "total_imported"
    t.integer "created_by",                      null: false
    t.integer "created_at",                      null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "textures", force: true do |t|
    t.string  "name",                limit: 100,             null: false
    t.string  "image_path"
    t.string  "original_image_name"
    t.integer "is_active",           limit: 1,   default: 1
    t.integer "created_by",                                  null: false
    t.integer "created_at",                                  null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "user_designs", force: true do |t|
    t.integer "user_id",                            null: false
    t.string  "name",                               null: false
    t.text    "html_info",         limit: 16777215, null: false
    t.string  "design_image_path"
    t.integer "created_by",                         null: false
    t.integer "created_at",                         null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  add_index "user_designs", ["user_id"], name: "userdes_fk", using: :btree

  create_table "user_details", force: true do |t|
    t.integer "user_id",                                   null: false
    t.string  "full_name",     limit: 110,                 null: false
    t.string  "email_id",                                  null: false
    t.string  "company_name",  limit: 100
    t.text    "address",       limit: 255
    t.string  "country",       limit: 20
    t.string  "city",          limit: 50
    t.string  "zipcode",       limit: 10
    t.string  "contact_no",    limit: 15
    t.string  "user_type"
    t.string  "profile_image"
    t.integer "is_active",     limit: 1,   default: 1
    t.boolean "is_deleted",                default: false
    t.integer "created_by",                                null: false
    t.integer "created_at",                                null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "users", force: true do |t|
    t.integer "role_id",                                             null: false
    t.string  "user_name",               limit: 100,                 null: false
    t.string  "user_password",           limit: 40,                  null: false
    t.integer "is_active",               limit: 1,   default: 1,     null: false
    t.string  "registered_user_ip",      limit: 15
    t.text    "reset_password_token",    limit: 255
    t.integer "reset_password_end_time"
    t.integer "last_login_date"
    t.string  "last_login_IP",           limit: 15
    t.boolean "is_deleted",                          default: false
    t.integer "created_by",                                          null: false
    t.integer "created_at",                                          null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  create_table "users_permissions", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "role_id",     null: false
    t.string  "menu_codes",  null: false
    t.integer "created_by",  null: false
    t.integer "created_at",  null: false
    t.integer "modified_by"
    t.integer "modified_at"
  end

  add_index "users_permissions", ["user_id"], name: "userper_fk", using: :btree

end
