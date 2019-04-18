# == Schema Information
#
# Table name: working_articles
#
#  id                           :integer          not null, primary key
#  grid_x                       :integer
#  grid_y                       :integer
#  column                       :integer
#  row                          :integer
#  order                        :integer
#  kind                         :string
#  profile                      :string
#  title                        :text
#  title_head                   :string
#  subtitle                     :text
#  subtitle_head                :string
#  body                         :text
#  reporter                     :string
#  email                        :string
#  image                        :string
#  quote                        :text
#  subject_head                 :string
#  on_left_edge                 :boolean
#  on_right_edge                :boolean
#  is_front_page                :boolean
#  top_story                    :boolean
#  top_position                 :boolean
#  inactive                     :boolean
#  extended_line_count          :integer
#  pushed_line_count            :integer
#  article_id                   :integer
#  page_id                      :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  quote_box_size               :integer
#  category_code                :integer
#  slug                         :string
#  publication_name             :string
#  path                         :string
#  date                         :date
#  page_number                  :integer
#  page_heading_margin_in_lines :integer
#  grid_width                   :float
#  grid_height                  :float
#  gutter                       :float
#  has_profile_image            :boolean
#  announcement_text            :string
#  announcement_column          :integer
#  announcement_color           :string
#  boxed_subtitle_type          :integer
#  boxed_subtitle_text          :string
#  subtitle_type                :string
#  overlap                      :text
#  embedded                     :boolean
#  heading_columns              :integer
#  quote_position               :integer
#  quote_x_grid                 :integer
#  quote_v_extra_space          :integer
#  quote_alignment              :string
#  quote_line_type              :string
#  quote_box_column             :integer
#  quote_box_type               :integer
#  quote_box_show               :boolean
#  draft_mode                   :boolean
#  y_in_lines                   :integer
#  height_in_lines              :integer
#
# Indexes
#
#  index_working_articles_on_article_id  (article_id)
#  index_working_articles_on_page_id     (page_id)
#  index_working_articles_on_slug        (slug) UNIQUE
#

require_relative '../test_helper'

class WorkingArticleTest < ActiveSupport::TestCase
  test "calculate_fitting_image_size" do
    assert true
  end
end
