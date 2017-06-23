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

ActiveRecord::Schema.define(version: 20170615110626) do

  create_table "ads", force: :cascade do |t|
    t.string   "name"
    t.integer  "column"
    t.integer  "row"
    t.integer  "page_columns"
    t.integer  "publication_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "column"
    t.integer  "row"
    t.integer  "order"
    t.integer  "profile"
    t.string   "title"
    t.string   "subtitle"
    t.text     "body"
    t.string   "reporter"
    t.string   "email"
    t.string   "personal_image"
    t.string   "image"
    t.string   "quote"
    t.string   "name_tag"
    t.boolean  "is_front_page"
    t.boolean  "top_story"
    t.boolean  "top_position"
    t.string   "kind"
    t.integer  "page_columns"
    t.integer  "publication_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["publication_id"], name: "index_articles_on_publication_id"
  end

  create_table "image_templates", force: :cascade do |t|
    t.integer  "column"
    t.integer  "row"
    t.integer  "height_in_lines"
    t.string   "image_path"
    t.string   "caption_title"
    t.string   "caption"
    t.integer  "position"
    t.integer  "page_columns"
    t.integer  "article_id"
    t.integer  "publication_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "column"
    t.integer  "row"
    t.integer  "height_in_lines"
    t.string   "image_path"
    t.string   "caption_title"
    t.string   "caption"
    t.integer  "position"
    t.integer  "page_number"
    t.integer  "story_number"
    t.boolean  "landscape"
    t.boolean  "used_in_layout"
    t.integer  "working_article_id"
    t.integer  "issue_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "issues", force: :cascade do |t|
    t.date     "date"
    t.string   "number"
    t.text     "plan"
    t.integer  "publication_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["publication_id"], name: "index_issues_on_publication_id"
  end

  create_table "page_headings", force: :cascade do |t|
    t.integer  "page_number"
    t.string   "section_name"
    t.string   "date"
    t.text     "layout"
    t.integer  "publication_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["publication_id"], name: "index_page_headings_on_publication_id"
  end

  create_table "pages", force: :cascade do |t|
    t.integer  "page_number"
    t.string   "section_name"
    t.integer  "column"
    t.integer  "row"
    t.string   "ad_type"
    t.integer  "story_count"
    t.boolean  "color_page"
    t.string   "profile"
    t.integer  "issue_id"
    t.integer  "template_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["issue_id"], name: "index_pages_on_issue_id"
  end

  create_table "placed_ads", force: :cascade do |t|
    t.string   "ad_type"
    t.integer  "column"
    t.integer  "row"
    t.string   "image_path"
    t.string   "advertiser"
    t.integer  "order"
    t.integer  "page_id"
    t.integer  "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publications", force: :cascade do |t|
    t.string   "name"
    t.string   "paper_size"
    t.float    "width"
    t.float    "height"
    t.float    "left_margin"
    t.float    "top_margin"
    t.float    "right_margin"
    t.float    "bottom_margin"
    t.integer  "lines_per_grid"
    t.float    "divider"
    t.float    "gutter"
    t.integer  "page_count"
    t.text     "section_names"
    t.string   "front_page_heading"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string   "profile"
    t.integer  "column"
    t.integer  "row"
    t.integer  "order"
    t.string   "ad_type"
    t.boolean  "is_front_page"
    t.integer  "story_count"
    t.integer  "page_number"
    t.string   "section_name"
    t.boolean  "color_page",       default: false
    t.integer  "divider_position"
    t.integer  "publication_id",   default: 1
    t.text     "layout"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "text_styles", force: :cascade do |t|
    t.string   "name"
    t.string   "english"
    t.string   "font_family"
    t.string   "font"
    t.float    "font_size"
    t.string   "color"
    t.string   "alignment"
    t.float    "tracking"
    t.float    "space_width"
    t.float    "scale"
    t.float    "text_line_spacing"
    t.integer  "space_before_in_lines"
    t.integer  "space_after_in_lines"
    t.integer  "text_height_in_lines"
    t.text     "box_attributes"
    t.integer  "used_column"
    t.integer  "publication_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["publication_id"], name: "index_text_styles_on_publication_id"
  end

  create_table "working_articles", force: :cascade do |t|
    t.integer  "column"
    t.integer  "row"
    t.integer  "order"
    t.string   "profile"
    t.text     "title"
    t.text     "subtitle"
    t.text     "body"
    t.string   "reporter"
    t.string   "email"
    t.string   "personal_image"
    t.string   "image"
    t.text     "quote"
    t.string   "name_tag"
    t.boolean  "is_front_page"
    t.boolean  "top_story"
    t.boolean  "top_position"
    t.integer  "page_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["page_id"], name: "index_working_articles_on_page_id"
  end

end
