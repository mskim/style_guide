# == Schema Information
#
# Table name: ad_boxes
#
#  id         :integer          not null, primary key
#  grid_x     :integer
#  grid_y     :integer
#  column     :integer
#  row        :integer
#  ad_type    :string
#  advertiser :string
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdBox < ApplicationRecord
  belongs_to :page
  has_one  :ad_image
  accepts_nested_attributes_for :ad_image
  after_create :setup

  def path
    page.path + "/ad"
  end

  def setup
    FileUtils.mkdir_p path unless File.exist?(path)
  end

  def publication
    page.publication
  end

  def issue
    page.issue
  end

  def jpg_image_path
    page.url + "/ad/output.jpg"
  end

  def publication
    page.publication
  end

  def gutter
    publication.gutter
  end

  def grid_width
    publication.grid_width(page.column)
  end

  def grid_height
    publication.grid_height
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

    image_path    = ad_image.image_path if ad_image
    content=<<~EOF
    RLayout::NewsAdBox.new(is_ad_box: true, width: #{ad_width}, left_inset: #{left_inset}, right_inset: #{right_inset}, height:#{ad_height}, top_margin: 13.849238095238096) do
      image(image_path: '#{image_path}', layout_expand: [:width, :height])
      relayout!
    end
    EOF

  end

  def layout_path
    path + "/layout.rb"
  end

  def save_layout
    puts __method__
    puts "layout_rb:#{layout_rb}"
    puts "layout_path:#{layout_path}"
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
    system "cd #{page_path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."
  end

  def box_svg
    "<a xlink:href='/ad_boxes/#{id}'><image xlink:href='#{jpg_image_path}' x='#{x}' y='#{y}' width='#{grid_width*column}' height='#{ad_height}' /></a>\n"
  end

end
