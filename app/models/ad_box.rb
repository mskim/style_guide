# == Schema Information
#
# Table name: ad_boxes
#
#  id         :integer          not null, primary key
#  grid_x     :integer
#  grid_y     :integer
#  column     :integer
#  row        :integer
#  order      :integer
#  ad_type    :string
#  advertiser :string
#  inactive   :boolean
#  ad_image   :string
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ad_boxes_on_page_id  (page_id)
#

class AdBox < ApplicationRecord
  belongs_to :page
  mount_uploader :ad_image, AdImageUploader
  after_create :setup

  def path
    page.path + "/ad"
  end

  def setup
    FileUtils.mkdir_p path unless File.exist?(path)
  end

  def issue
    page.issue
  end

  def pdf_image_path
    page.url + "/ad/output.pdf"
  end

  def jpg_image_path
    page.url + "/ad/output.jpg"
  end

  def jpg_path
    path + "/output.jpg"
  end

  def pdf_path
    path + "/output.pdf"
  end

  def publication
    if page
      page.publication
    else
      #TODO
      Publication.first
    end
  end

  def page_number
    page.page_number
  end

  def gutter
    publication.gutter
  end

  def grid_width
    publication.grid_width(page.column)
  end

  def width
    grid_width*column
  end

  def grid_height
    publication.grid_height
  end

  def height
    grid_height*row
  end

  def x
    grid_width*grid_x
  end

  def y
    grid_height*grid_y
  end

  def ad_height
    grid_height*row
  end

  def top_position?
    grid_y == 0 || (grid_y == 1 && page.page_number == 1)
  end

  def on_left_edge?
    grid_x == 0
  end

  def on_right_edge?
    grid_x + column == page.column
  end

  def is_front_page?
    page.page_number == 1
  end

  def layout_rb
    x             = publication.left_margin
    left_inset    = 0
    right_inset   = 0
    ad_width      = grid_width*column
    if page.page_number.odd?
      x = publication.width - publication.right_margin - ad_width
      if column < page.column
        x += gutter/2
        ad_width -= gutter
        left_inset = gutter
      end
    else
      if column < page.column
        ad_width -= gutter
        right_inset = gutter
      end
    end
    page_heading_margin_in_lines = 0
    if top_position?
      if is_front_page?
        # front_page_heading_height - lines_per_grid
        page_heading_margin_in_lines = publication.front_page_heading_margin
      else
        page_heading_margin_in_lines = publication.inner_page_heading_height
      end
    end

    image_path                                     = ad_image.path if ad_image
    ad_image_hash = {}
    ad_image_hash[:layout_expand]                  = [:width, :height]
    ad_image_hash[:page_heading_margin_in_lines]   = page_heading_margin_in_lines
    content=<<~EOF
    RLayout::NewsAdBox.new(is_ad_box: true, column: #{column}, row: #{row}, grid_width: #{grid_width}, grid_height: #{grid_height}, on_left_edge: #{on_left_edge?}, top_position: #{top_position?}, on_right_edge: #{on_right_edge?}, page_heading_margin_in_lines: #{page_heading_margin_in_lines}) do
      image(image_path: '#{image_path}', fit_type: 4, layout_expand: [:width, :height])
      relayout!
    end
    EOF
  end

  def layout_path
    path + "/layout.rb"
  end

  def save_layout
    File.open(layout_path, 'w'){|f| f.write layout_rb}
    puts "File.exist?(layout_path):#{File.exist?(layout_path)}"
  end

  def generate_pdf
    save_layout
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    update_page_pdf
  end

  def update_page_pdf
    page_path = page.path
    puts "page_path:#{page_path}"
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
  end

  def box_svg
    "<a xlink:href='/ad_boxes/#{id}'><rect fill-opacity='0.0' x='#{x}' y='#{y}' width='#{grid_width*column}' height='#{ad_height}' /></a>\n"
  end

  def save_story_xml
    FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
    path = "#{newsml_issue_path}/#{story_xml_filename}"
    File.open(path, 'w'){|f| f.write story_xml}
    save_xml_image
  end

  def section_name_code
    case page.section_name
    when '1면'
      code = "0009"
    when '정치'
      code = "0002"
    when '행정'
      code = "0003"
    when '국제통일'
      code = "0004"
    when '금융'
      code = "0007"
    when '산업'
      code = "0006"
    when '기획'
      code= "0001"
    when '정책'
      code = "0005"
    when '오피니언'
      code = "0008"
    end
    code
  end

  def ad_xml
    story_erb_path = "#{Rails.root}/public/1/newsml/story_xml.erb"
    story_xml_template = File.open(story_erb_path, 'r'){|f| f.read}
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    hour  = updated_at.hour.to_s.rjust(2, "0")
    min   = updated_at.min.to_s.rjust(2, "0")
    sec   = updated_at.sec.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    updated_date      = "#{year}#{month}#{day}"
    updated_time      = "#{hour}#{min}#{sec}+0900"
    @date_and_time    = "#{updated_date}T#{updated_time}"
    @date_id          = updated_date
    @news_key_id      = "#{updated_date}.011001#{page_info}0000#{two_digit_ord}"
    @day_info         = "#{year}년#{month}월#{day}일"
    @media_info       = publication.name
    # @edition_info     = page_number.to_s.rjust(2,"0")
    # @page_info        = publication.paper_size
    @page_info        = page_number.to_s.rjust(2,"0")
    @jeho_info        = issue.number

    if page.section_name = '오피니언'
      @news_title_info = '논설'
    else
      @news_title_info  = page.section_name
    end
    @section_name_code = section_name_code

    @gisa_key         = "#{@date_id}001#{@page_info}#{two_digit_ord}"
    @data_content       = advertiser

    story_erb = ERB.new(story_xml_template)
    story_erb.result(binding)
    story_erb = ERB.new(story_xml_template)
    story_erb.result(binding)
  end

  def newsml_issue_path
    "#{Rails.root}/public/1/issue/#{issue.date}/newsml"
  end

  def two_digit_ord
    (page.working_articles.length + 1).to_s.rjust(2, "0")
  end

  def save_ad_xml
    FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
    path = "#{newsml_issue_path}/#{story_xml_filename}"
    File.open(path, 'w'){|f| f.write ad_xml}
  end

  def story_xml_filename
    date_without_minus = issue.date.to_s.gsub("-","")
    two_digit_page_number = page_number.to_s.rjust(2, "0")
    "#{date_without_minus}.011001#{two_digit_page_number}0000#{two_digit_ord}.xml"
  end

end
