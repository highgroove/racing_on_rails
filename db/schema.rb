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

ActiveRecord::Schema.define(:version => 20120813183838) do

  create_table "aliases", :force => true do |t|
    t.string   "alias"
    t.string   "name"
    t.integer  "person_id"
    t.integer  "team_id"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliases", ["alias"], :name => "idx_id"
  add_index "aliases", ["name"], :name => "idx_name", :unique => true
  add_index "aliases", ["person_id"], :name => "idx_racer_id"
  add_index "aliases", ["team_id"], :name => "idx_team_id"

  create_table "article_categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id",   :default => 0
    t.integer  "position",    :default => 0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "heading"
    t.string   "description"
    t.boolean  "display"
    t.text     "body"
    t.integer  "position",            :default => 0
    t.integer  "article_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", :force => true do |t|
    t.string   "name",                        :null => false
    t.string   "email",                       :null => false
    t.string   "phone",                       :null => false
    t.integer  "amount",                      :null => false
    t.boolean  "approved"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "position",                     :default => 0,   :null => false
    t.string   "name",           :limit => 64, :default => "",  :null => false
    t.integer  "lock_version",                 :default => 0,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "ages_begin",                   :default => 0
    t.integer  "ages_end",                     :default => 999
    t.string   "friendly_param",                                :null => false
  end

  add_index "categories", ["friendly_param"], :name => "index_categories_on_friendly_param"
  add_index "categories", ["name"], :name => "categories_name_index", :unique => true
  add_index "categories", ["parent_id"], :name => "parent_id"

  create_table "competition_event_memberships", :force => true do |t|
    t.integer "competition_id",                  :null => false
    t.integer "event_id",                        :null => false
    t.float   "points_factor",  :default => 1.0
  end

  add_index "competition_event_memberships", ["competition_id"], :name => "index_competition_event_memberships_on_competition_id"
  add_index "competition_event_memberships", ["event_id"], :name => "index_competition_event_memberships_on_event_id"

  create_table "discipline_aliases", :id => false, :force => true do |t|
    t.integer  "discipline_id",               :default => 0,  :null => false
    t.string   "alias",         :limit => 64, :default => "", :null => false
    t.integer  "lock_version",                :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discipline_aliases", ["alias"], :name => "idx_alias"
  add_index "discipline_aliases", ["discipline_id"], :name => "idx_discipline_id"

  create_table "discipline_bar_categories", :id => false, :force => true do |t|
    t.integer "category_id",   :default => 0, :null => false
    t.integer "discipline_id", :default => 0, :null => false
  end

  add_index "discipline_bar_categories", ["category_id", "discipline_id"], :name => "discipline_bar_categories_category_id_index", :unique => true
  add_index "discipline_bar_categories", ["category_id"], :name => "idx_category_id"
  add_index "discipline_bar_categories", ["discipline_id"], :name => "idx_discipline_id"

  create_table "disciplines", :force => true do |t|
    t.string   "name",         :limit => 64, :default => "",    :null => false
    t.boolean  "bar"
    t.integer  "lock_version",               :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "numbers",                    :default => false
  end

  add_index "disciplines", ["name"], :name => "index_disciplines_on_name", :unique => true

  create_table "duplicates", :force => true do |t|
    t.text "new_attributes"
  end

  create_table "duplicates_people", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "duplicate_id"
  end

  add_index "duplicates_people", ["duplicate_id"], :name => "index_duplicates_racers_on_duplicate_id"
  add_index "duplicates_people", ["person_id", "duplicate_id"], :name => "index_duplicates_racers_on_racer_id_and_duplicate_id", :unique => true
  add_index "duplicates_people", ["person_id"], :name => "index_duplicates_racers_on_racer_id"

  create_table "duplicates_racers", :id => false, :force => true do |t|
    t.integer "racer_id"
    t.integer "duplicate_id"
  end

  add_index "duplicates_racers", ["duplicate_id"], :name => "index_duplicates_racers_on_duplicate_id"
  add_index "duplicates_racers", ["racer_id", "duplicate_id"], :name => "index_duplicates_racers_on_racer_id_and_duplicate_id", :unique => true
  add_index "duplicates_racers", ["racer_id"], :name => "index_duplicates_racers_on_racer_id"

  create_table "editor_requests", :force => true do |t|
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "person_id",                   :null => false
    t.integer  "editor_id",                   :null => false
    t.datetime "expires_at",                  :null => false
    t.string   "token",                       :null => false
    t.string   "email",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "editor_requests", ["editor_id", "person_id"], :name => "index_editor_requests_on_editor_id_and_person_id", :unique => true
  add_index "editor_requests", ["editor_id"], :name => "index_editor_requests_on_editor_id"
  add_index "editor_requests", ["expires_at"], :name => "index_editor_requests_on_expires_at"
  add_index "editor_requests", ["person_id"], :name => "index_editor_requests_on_person_id"
  add_index "editor_requests", ["token"], :name => "index_editor_requests_on_token"

  create_table "editors_events", :id => false, :force => true do |t|
    t.integer "event_id",  :null => false
    t.integer "editor_id", :null => false
  end

  add_index "editors_events", ["editor_id"], :name => "index_editors_events_on_editor_id"
  add_index "editors_events", ["event_id"], :name => "index_editors_events_on_event_id"

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.string  "engine_name"
    t.integer "version"
  end

  create_table "events", :force => true do |t|
    t.integer  "parent_id"
    t.string   "city",                     :limit => 128
    t.date     "date"
    t.string   "discipline",               :limit => 32
    t.string   "flyer"
    t.string   "name"
    t.string   "notes",                                   :default => ""
    t.string   "sanctioned_by"
    t.string   "state",                    :limit => 64
    t.string   "type",                     :limit => 32
    t.integer  "lock_version",                            :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "flyer_approved",                          :default => false, :null => false
    t.boolean  "cancelled",                               :default => false
    t.boolean  "notification",                            :default => true
    t.integer  "number_issuer_id"
    t.string   "first_aid_provider"
    t.float    "pre_event_fees"
    t.float    "post_event_fees"
    t.float    "flyer_ad_fee"
    t.string   "prize_list"
    t.integer  "velodrome_id"
    t.string   "time"
    t.boolean  "instructional",                           :default => false
    t.boolean  "practice",                                :default => false
    t.boolean  "atra_points_series",                      :default => false, :null => false
    t.integer  "bar_points",                                                 :null => false
    t.boolean  "ironman",                                                    :null => false
    t.boolean  "auto_combined_results",                   :default => true,  :null => false
    t.integer  "team_id"
    t.string   "sanctioning_org_event_id", :limit => 16
    t.integer  "promoter_id"
    t.string   "phone"
    t.string   "email"
    t.boolean  "postponed",                               :default => false, :null => false
    t.string   "chief_referee"
    t.boolean  "beginner_friendly",                       :default => false, :null => false
    t.string   "website"
    t.string   "registration_link"
    t.string   "twitter_tag"
  end

  add_index "events", ["bar_points"], :name => "index_events_on_bar_points"
  add_index "events", ["date"], :name => "idx_date"
  add_index "events", ["discipline"], :name => "idx_disciplined"
  add_index "events", ["number_issuer_id"], :name => "events_number_issuer_id_index"
  add_index "events", ["parent_id"], :name => "parent_id"
  add_index "events", ["promoter_id"], :name => "index_events_on_promoter_id"
  add_index "events", ["sanctioned_by"], :name => "index_events_on_sanctioned_by"
  add_index "events", ["type"], :name => "idx_type"
  add_index "events", ["type"], :name => "index_events_on_type"
  add_index "events", ["velodrome_id"], :name => "velodrome_id"

  create_table "historical_names", :force => true do |t|
    t.integer  "team_id",                     :null => false
    t.string   "name",                        :null => false
    t.integer  "year",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "historical_names", ["name"], :name => "index_names_on_name"
  add_index "historical_names", ["team_id"], :name => "team_id"
  add_index "historical_names", ["year"], :name => "index_names_on_year"

  create_table "images", :force => true do |t|
    t.string   "caption"
    t.string   "html_options"
    t.string   "link"
    t.string   "name",                        :null => false
    t.string   "source",                      :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["name"], :name => "images_name_index", :unique => true

  create_table "import_files", :force => true do |t|
    t.string   "name",                        :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_lists", :force => true do |t|
    t.string   "name",                :default => "", :null => false
    t.string   "friendly_name",       :default => "", :null => false
    t.string   "subject_line_prefix", :default => "", :null => false
    t.integer  "lock_version",        :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "mailing_lists", ["name"], :name => "idx_name"

  create_table "names", :force => true do |t|
    t.integer  "nameable_id",                  :null => false
    t.string   "name",                         :null => false
    t.integer  "year",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0, :null => false
    t.string   "nameable_type"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "names", ["name"], :name => "index_names_on_name"
  add_index "names", ["nameable_id"], :name => "team_id"
  add_index "names", ["nameable_type"], :name => "index_names_on_nameable_type"
  add_index "names", ["year"], :name => "index_names_on_year"

  create_table "news_items", :force => true do |t|
    t.date     "date",                        :null => false
    t.string   "text",                        :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_items", ["date"], :name => "news_items_date_index"
  add_index "news_items", ["text"], :name => "news_items_text_index"

  create_table "number_issuers", :force => true do |t|
    t.string   "name",         :default => "", :null => false
    t.integer  "lock_version", :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "number_issuers", ["name"], :name => "number_issuers_name_index", :unique => true

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "body",                         :null => false
    t.string   "path",         :default => "", :null => false
    t.string   "slug",         :default => "", :null => false
    t.string   "title",        :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0,  :null => false
  end

  add_index "pages", ["parent_id"], :name => "parent_id"
  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true
  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "people", :force => true do |t|
    t.string   "first_name",              :limit => 64
    t.string   "last_name"
    t.string   "city",                    :limit => 128
    t.date     "date_of_birth"
    t.string   "license",                 :limit => 64
    t.text     "notes"
    t.string   "state",                   :limit => 64
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cell_fax"
    t.string   "ccx_category"
    t.string   "dh_category"
    t.string   "email"
    t.string   "gender",                  :limit => 2
    t.string   "home_phone"
    t.string   "mtb_category"
    t.date     "member_from"
    t.string   "occupation"
    t.string   "road_category"
    t.string   "street"
    t.string   "track_category"
    t.string   "work_phone"
    t.string   "zip"
    t.date     "member_to"
    t.boolean  "print_card",                             :default => false
    t.boolean  "ccx_only",                               :default => false, :null => false
    t.string   "bmx_category"
    t.boolean  "wants_email",                            :default => false, :null => false
    t.boolean  "wants_mail",                             :default => false, :null => false
    t.boolean  "volunteer_interest",                     :default => false, :null => false
    t.boolean  "official_interest",                      :default => false, :null => false
    t.boolean  "race_promotion_interest",                :default => false, :null => false
    t.boolean  "team_interest",                          :default => false, :null => false
    t.date     "member_usac_to"
    t.string   "status"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                         :null => false
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                            :default => 0,     :null => false
    t.integer  "failed_login_count",                     :default => 0,     :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "login",                   :limit => 100
    t.date     "license_expiration_date"
    t.string   "club_name"
    t.string   "ncca_club_name"
    t.string   "emergency_contact"
    t.string   "emergency_contact_phone"
    t.datetime "card_printed_at"
    t.string   "license_type"
    t.string   "country_code",            :limit => 2,   :default => "US"
    t.boolean  "membership_card",                        :default => false, :null => false
    t.boolean  "official",                               :default => false, :null => false
    t.string   "name",                                   :default => "",    :null => false
  end

  add_index "people", ["crypted_password"], :name => "index_people_on_crypted_password"
  add_index "people", ["email"], :name => "index_people_on_email"
  add_index "people", ["first_name"], :name => "idx_first_name"
  add_index "people", ["last_name"], :name => "idx_last_name"
  add_index "people", ["license"], :name => "index_people_on_license"
  add_index "people", ["login"], :name => "index_people_on_login"
  add_index "people", ["member_from"], :name => "index_racers_on_member_from"
  add_index "people", ["member_to"], :name => "index_racers_on_member_to"
  add_index "people", ["name"], :name => "index_people_on_name"
  add_index "people", ["perishable_token"], :name => "index_people_on_perishable_token"
  add_index "people", ["persistence_token"], :name => "index_people_on_persistence_token"
  add_index "people", ["print_card"], :name => "index_people_on_print_card"
  add_index "people", ["single_access_token"], :name => "index_people_on_single_access_token"
  add_index "people", ["team_id"], :name => "idx_team_id"

  create_table "people_people", :id => false, :force => true do |t|
    t.integer "person_id", :null => false
    t.integer "editor_id", :null => false
  end

  add_index "people_people", ["editor_id", "person_id"], :name => "index_people_people_on_editor_id_and_person_id", :unique => true
  add_index "people_people", ["editor_id"], :name => "index_people_people_on_editor_id"
  add_index "people_people", ["person_id"], :name => "index_people_people_on_person_id"

  create_table "post_texts", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_texts", ["post_id"], :name => "index_post_texts_on_post_id"
  add_index "post_texts", ["text"], :name => "post_text"

  create_table "posts", :force => true do |t|
    t.text     "body",                              :null => false
    t.datetime "date",                              :null => false
    t.string   "sender",            :default => "", :null => false
    t.string   "subject",           :default => "", :null => false
    t.string   "topica_message_id"
    t.integer  "lock_version",      :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mailing_list_id",   :default => 0,  :null => false
    t.integer  "position",          :default => 0,  :null => false
  end

  add_index "posts", ["date", "mailing_list_id"], :name => "idx_date_list"
  add_index "posts", ["date"], :name => "idx_date"
  add_index "posts", ["mailing_list_id"], :name => "idx_mailing_list_id"
  add_index "posts", ["position"], :name => "index_posts_on_position"
  add_index "posts", ["sender"], :name => "idx_sender"
  add_index "posts", ["subject"], :name => "idx_subject"
  add_index "posts", ["topica_message_id"], :name => "idx_topica_message_id", :unique => true

  create_table "promoters", :force => true do |t|
    t.string   "email"
    t.string   "name",         :default => ""
    t.string   "phone"
    t.integer  "lock_version", :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promoters", ["name", "email", "phone"], :name => "promoter_info", :unique => true
  add_index "promoters", ["name"], :name => "idx_name"

  create_table "race_numbers", :force => true do |t|
    t.integer  "person_id",        :default => 0,  :null => false
    t.integer  "discipline_id",    :default => 0,  :null => false
    t.integer  "number_issuer_id", :default => 0,  :null => false
    t.string   "value",            :default => "", :null => false
    t.integer  "year",             :default => 0,  :null => false
    t.integer  "lock_version",     :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "race_numbers", ["discipline_id"], :name => "discipline_id"
  add_index "race_numbers", ["number_issuer_id"], :name => "number_issuer_id"
  add_index "race_numbers", ["person_id"], :name => "racer_id"
  add_index "race_numbers", ["value"], :name => "race_numbers_value_index"
  add_index "race_numbers", ["year"], :name => "index_race_numbers_on_year"

  create_table "racers", :force => true do |t|
    t.string   "first_name",          :limit => 64
    t.string   "last_name"
    t.string   "city",                :limit => 128
    t.date     "date_of_birth"
    t.string   "license",             :limit => 64
    t.text     "notes"
    t.string   "state",               :limit => 64
    t.integer  "team_id"
    t.integer  "lock_version",                       :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cell_fax"
    t.string   "ccx_category"
    t.string   "dh_category"
    t.string   "email"
    t.string   "gender",              :limit => 2
    t.string   "home_phone"
    t.string   "mtb_category"
    t.date     "member_from"
    t.string   "occupation"
    t.string   "road_category"
    t.string   "street"
    t.string   "track_category"
    t.string   "work_phone"
    t.string   "zip"
    t.date     "member_to"
    t.boolean  "print_card",                         :default => false
    t.boolean  "print_mailing_label",                :default => false
    t.boolean  "ccx_only",                           :default => false, :null => false
    t.string   "updated_by"
    t.string   "bmx_category"
    t.boolean  "wants_email",                        :default => true,  :null => false
    t.boolean  "wants_mail",                         :default => true,  :null => false
  end

  add_index "racers", ["first_name"], :name => "idx_first_name"
  add_index "racers", ["last_name"], :name => "idx_last_name"
  add_index "racers", ["team_id"], :name => "idx_team_id"

  create_table "races", :force => true do |t|
    t.integer  "category_id",                                   :null => false
    t.string   "city",           :limit => 128
    t.string   "distance"
    t.string   "state",          :limit => 64
    t.integer  "field_size"
    t.integer  "laps"
    t.float    "time"
    t.integer  "finishers"
    t.string   "notes",                         :default => ""
    t.string   "sanctioned_by"
    t.integer  "lock_version",                  :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "result_columns"
    t.integer  "bar_points"
    t.integer  "event_id",                                      :null => false
    t.text     "custom_columns"
  end

  add_index "races", ["bar_points"], :name => "index_races_on_bar_points"
  add_index "races", ["category_id"], :name => "idx_category_id"
  add_index "races", ["event_id"], :name => "index_races_on_event_id"

  create_table "racing_associations", :force => true do |t|
    t.boolean  "add_members_from_results",                           :default => true,                                  :null => false
    t.boolean  "always_insert_table_headers",                        :default => true,                                  :null => false
    t.boolean  "award_cat4_participation_points",                    :default => true,                                  :null => false
    t.boolean  "bmx_numbers",                                        :default => false,                                 :null => false
    t.boolean  "cx_memberships",                                     :default => false,                                 :null => false
    t.boolean  "eager_match_on_license",                             :default => false,                                 :null => false
    t.boolean  "flyers_in_new_window",                               :default => false,                                 :null => false
    t.boolean  "gender_specific_numbers",                            :default => false,                                 :null => false
    t.boolean  "include_multiday_events_on_schedule",                :default => false,                                 :null => false
    t.boolean  "show_all_teams_on_public_page",                      :default => false,                                 :null => false
    t.boolean  "show_calendar_view",                                 :default => true,                                  :null => false
    t.boolean  "show_events_velodrome",                              :default => true,                                  :null => false
    t.boolean  "show_license",                                       :default => true,                                  :null => false
    t.boolean  "show_only_association_sanctioned_races_on_calendar", :default => true,                                  :null => false
    t.boolean  "show_practices_on_calendar",                         :default => false,                                 :null => false
    t.boolean  "ssl",                                                :default => false,                                 :null => false
    t.boolean  "usac_results_format",                                :default => false,                                 :null => false
    t.integer  "cat4_womens_race_series_category_id"
    t.integer  "lock_version",                                       :default => 0,                                     :null => false
    t.integer  "masters_age",                                        :default => 35,                                    :null => false
    t.integer  "rental_numbers_end",                                 :default => 99,                                    :null => false
    t.integer  "rental_numbers_start",                               :default => 51,                                    :null => false
    t.integer  "search_results_limit",                               :default => 100,                                   :null => false
    t.integer  "weeks_of_recent_results",                            :default => 2,                                     :null => false
    t.integer  "weeks_of_upcoming_events",                           :default => 5,                                     :null => false
    t.string   "cat4_womens_race_series_points"
    t.string   "administrator_tabs"
    t.string   "competitions"
    t.string   "country_code",                                       :default => "US",                                  :null => false
    t.string   "default_discipline",                                 :default => "Road",                                :null => false
    t.string   "default_sanctioned_by"
    t.string   "email",                                              :default => "scott.willson@gmail.com",             :null => false
    t.string   "exempt_team_categories",                             :default => "0",                                   :null => false
    t.string   "membership_email",                                   :default => "scott.willson@gmail.com",             :null => false
    t.string   "name",                                               :default => "Cascadia Bicycle Racing Association", :null => false
    t.string   "rails_host",                                         :default => "localhost:3000"
    t.string   "sanctioning_organizations"
    t.string   "short_name",                                         :default => "CBRA",                                :null => false
    t.string   "show_events_sanctioning_org_event_id",               :default => "0",                                   :null => false
    t.string   "state",                                              :default => "OR",                                  :null => false
    t.string   "static_host",                                        :default => "localhost",                           :null => false
    t.string   "usac_region",                                        :default => "North West",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "cat4_womens_race_series_end_date"
    t.boolean  "unregistered_teams_in_results",                      :default => true,                                  :null => false
    t.date     "next_year_start_at"
    t.boolean  "mobile_site",                                        :default => false,                                 :null => false
    t.date     "cat4_womens_race_series_start_date"
  end

  create_table "results", :force => true do |t|
    t.integer  "category_id"
    t.integer  "person_id"
    t.integer  "race_id",                                                  :null => false
    t.integer  "team_id"
    t.integer  "age"
    t.string   "city",                    :limit => 128
    t.datetime "date_of_birth"
    t.boolean  "is_series"
    t.string   "license",                 :limit => 64,  :default => ""
    t.string   "notes"
    t.string   "number",                  :limit => 16,  :default => ""
    t.string   "place",                   :limit => 8,   :default => ""
    t.integer  "place_in_category",                      :default => 0
    t.float    "points",                                 :default => 0.0
    t.float    "points_from_place",                      :default => 0.0
    t.float    "points_bonus_penalty",                   :default => 0.0
    t.float    "points_total",                           :default => 0.0
    t.string   "state",                   :limit => 64
    t.string   "status",                  :limit => 3
    t.float    "time"
    t.float    "time_bonus_penalty"
    t.float    "time_gap_to_leader"
    t.float    "time_gap_to_previous"
    t.float    "time_gap_to_winner"
    t.integer  "lock_version",                           :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "time_total"
    t.integer  "laps"
    t.string   "members_only_place",      :limit => 8
    t.integer  "points_bonus",                           :default => 0,    :null => false
    t.integer  "points_penalty",                         :default => 0,    :null => false
    t.boolean  "preliminary"
    t.boolean  "bar",                                    :default => true
    t.string   "gender",                  :limit => 8
    t.string   "category_class",          :limit => 16
    t.string   "age_group",               :limit => 16
    t.text     "custom_attributes"
    t.boolean  "competition_result",                                       :null => false
    t.boolean  "team_competition_result",                                  :null => false
    t.string   "category_name"
    t.string   "event_date_range_s",                                       :null => false
    t.date     "date",                                                     :null => false
    t.date     "event_end_date",                                           :null => false
    t.integer  "event_id",                                                 :null => false
    t.string   "event_full_name",                                          :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "race_name",                                                :null => false
    t.string   "race_full_name",                                           :null => false
    t.string   "team_name"
    t.integer  "year",                                                     :null => false
  end

  add_index "results", ["category_id"], :name => "idx_category_id"
  add_index "results", ["event_id"], :name => "index_results_on_event_id"
  add_index "results", ["members_only_place"], :name => "index_results_on_members_only_place"
  add_index "results", ["person_id"], :name => "idx_racer_id"
  add_index "results", ["place"], :name => "index_results_on_place"
  add_index "results", ["race_id"], :name => "idx_race_id"
  add_index "results", ["team_id"], :name => "idx_team_id"
  add_index "results", ["year"], :name => "index_results_on_year"

  create_table "role_assignments", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "person_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_assignments", ["person_id"], :name => "index_people_roles_on_person_id"
  add_index "role_assignments", ["role_id"], :name => "role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "competition_result_id"
    t.integer  "source_result_id"
    t.float    "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.string   "description"
    t.string   "event_name"
  end

  add_index "scores", ["competition_result_id"], :name => "scores_competition_result_id_index"
  add_index "scores", ["source_result_id"], :name => "scores_source_result_id_index"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "standings", :force => true do |t|
    t.integer  "event_id",                              :default => 0,    :null => false
    t.integer  "bar_points",                            :default => 1
    t.string   "name"
    t.integer  "lock_version",                          :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ironman",                               :default => true
    t.integer  "position",                              :default => 0
    t.string   "discipline",              :limit => 32
    t.string   "notes",                                 :default => ""
    t.integer  "source_id"
    t.string   "type",                    :limit => 32
    t.boolean  "auto_combined_standings",               :default => true
  end

  add_index "standings", ["event_id"], :name => "event_id"
  add_index "standings", ["source_id"], :name => "source_id"

  create_table "teams", :force => true do |t|
    t.string   "name",                                :default => "",    :null => false
    t.string   "city",                :limit => 128
    t.string   "state",               :limit => 64
    t.string   "notes"
    t.integer  "lock_version",                        :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "member",                              :default => false
    t.string   "website"
    t.string   "sponsors",            :limit => 1000
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.boolean  "show_on_public_page",                 :default => false
  end

  add_index "teams", ["name"], :name => "idx_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",         :default => "", :null => false
    t.string   "username",     :default => "", :null => false
    t.string   "password",     :default => "", :null => false
    t.integer  "lock_version", :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "idx_alias", :unique => true

  create_table "velodromes", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "velodromes", ["name"], :name => "index_velodromes_on_name"

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reverted_from"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
