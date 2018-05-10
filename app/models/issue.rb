# == Schema Information
#
# Table name: issues
#
#  id             :integer          not null, primary key
#  date           :date
#  number         :string
#  plan           :text
#  publication_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_issues_on_publication_id  (publication_id)
#

class Issue < ApplicationRecord
  belongs_to :publication
  has_many  :page_plans
  has_many  :pages, -> {order(id: :asc)}
  has_many  :images
  accepts_nested_attributes_for :images
  has_many  :ad_images
  accepts_nested_attributes_for :ad_images

  before_create :read_issue_plan
  after_create :setup
  # validates_presence_of :date
  # validates_uniqueness_of :date

  def path
    "#{Rails.root}/public/#{publication_id}/issue/#{date.to_s}"
  end

  def relative_path
    "#{publication_id}/issue/#{date.to_s}"
  end

  def default_issue_plan_path
    "#{Rails.root}/public/#{publication_id}/default_issue_plan.rb"
  end

  def default_issue_path
    "#{Rails.root}/public/#{publication_id}/default_issue_plan"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    system "mkdir -p #{issue_images_path}" unless File.directory?(issue_images_path)
    system "mkdir -p #{issue_ads_path}" unless File.directory?(issue_ads_path)
    # make_default_issue_plan
    # make_pages
  end

  def section_path
    "#{Rails.root}/public/#{publication_id}/section"
  end

  def newsml_path
    "#{Rails.root}/public/1/newsml"
  end

  def newsml_issue_path
    "#{Rails.root}/public/1/#{id}/newsml"
  end

  def eval_issue_plan
    eval(plan)
  end

  def issue_images_path
    path + "/images"
  end

  def issue_ads_path
    path + "/ads"
  end

  def issue_ad_list_path
    path + "/ads/ad_list.yml"
  end

  def issue_info_for_cms
    {
      'id' => id,
      'date' => date.to_s,
      'plan' => plan
    }
  end

  def current_working_articles_hash
    #code
  end

  def request_cms_new_issue
    puts __method__
    # cms_address = 'http://localhost:3001'
    # puts "#{cms_address}/#{id}"
    # RestClient.post( "#{cms_address}/api/v1/cms_new_issue/#{id}", {'payload' => issue_info_for_cms})
  end

  def news_cms_host
    "http://localhost:3001"
  end

  def news_cms_head
    "#{news_cms_host}/update_issue_plan"
  end

  def make_default_issue_plan
    # page_array = [page_number, profile]
    section_names_array = eval(publication.section_names)
    eval_issue_plan.each_with_index do |page_array, i|
      page_hash                 = {}
      page_hash[:issue_id]       = self.id
      page_hash[:section_name]  = section_names_array[i]
      page_hash[:page_number]   = page_array[0]
      page_hash[:profile]       = page_array[1]
      p = PagePlan.where(page_hash).first_or_create!
    end
  end

  def update_plan
    change_or_make_pages
    # parse_images
    # parse_ad_images
    # parse_graphics
  end

  def make_pages
    puts "in make_pages"
    page_plans.each_with_index do |page_plan, i|
      Page.create!(issue_id: self.id, page_plan_id: page_plan.id, template_id: page_plan.selected_template_id)
      page_plan.dirty = false
      page_plan.save
    end
  end

  def change_or_make_pages
    page_plans.each_with_index do |page_plan, i|
      if page_plan.page
        if page_plan.need_update?
          page_plan.page.change_template(page_plan.selected_template_id)
          page_plan.dirty = false
          page_plan.save
        end
        next
      else
        # create new page
        page_plan.page = Page.create!(issue_id: self.id, page_plan_id: page_plan.id, template_id: page_plan.selected_template_id)
        page_plan.dirty = false
        page_plan.save
      end
    end
  end

  def page_plan_with_ad
    list = []
    page_plans.each do |pp|
      list << pp if pp.ad_type
    end
    list
  end

  def ad_list
    list = []
    pages.each do |page|
      list << page.ad_info if page.ad_info
    end
    return false if list.length > 0
    list.to_yaml
  end

  def save_ad_info
    system("mkdir -p #{issue_ads_path}") unless File.directory?(issue_ads_path)
    File.open(issue_ad_list_path, 'w'){|f| f.write.ad_list} if ad_list
  end

  def parse_images
    Dir.glob("#{issue_images_path}/*{.jpg,.pdf}").each  do |image|
      puts "+++++ image:#{image}"
      h = {}
      issue_image_basename  = File.basename(image)
      profile_array         = issue_image_basename.split("_")
      puts "profile_array:#{profile_array}"
      next if profile_array.length < 2
      puts "profile_array.length:#{profile_array.length}"
      # h[:image_path]        = image
      h[:page_number]       = profile_array[0].to_i
      h[:story_number]      = profile_array[1].to_i
      h[:column]            = 2
      h[:column]            = profile_array[2].to_i if  profile_array.length > 3
      h[:landscape]         = true
      h[:caption_title]     = "사진설먕 제목"
      h[:caption]           = "사진설먕운 여기에 사진설명은 여기에 사진설명은 여기에 사진설명"
      h[:position]          = 3 #top_right 상단_우측
      #TODO read image file and determin orientaion from it.
      h[:used_in_layout]    = false
      h[:landscape]         = profile_array[3] if  profile_array.length > 4
      if h[:landscape]
        h[:row]             = h[:column]
      else
        h[:row]       = h[:column] + 1
      end
      h[:extra_height_in_lines]   = h[:row] * publication.lines_per_grid
      h[:issue_id]          = self.id
      # h[:column]            = profile_array[2] if  profile_array.length > 3
      page = Page.where(issue_id: self, page_number: h[:page_number]).first
      puts "h[:issue_id]:#{h[:issue_id]}"
      puts "h[:page_number]:#{h[:page_number]}"
      unless page
        puts "Page: #{h[:page_number]} doesn't exist!!!!"
        next
      end
      working_article = WorkingArticle.where(page_id: page.id, order: h[:story_number]).first
      if working_article
        h[:working_article_id] = working_article.id
        puts "h:#{h}"
        Image.where(h).first_or_create
      #TODO create symbolic link
      else
        puts "article at page:#{h[:page_number]} story_number: #{h[:story_number]} not found!!!}"
      end
    end

  end

  def parse_ad_images

    Dir.glob("#{issue_ads_path}/*{.jpg,.pdf}").each  do |ad|
      h = {}
      h[:image_path]        = ad
      h[:issue_id]          = self
      AdImage.where(h).first_or_create
    end
  end

  def parse_graphics
    puts __method__
  end

  def ad_list
    list = []
    pages.each do |page|
      page.ad_images
    end

  end

  def save_issue_plan_ad
    pages.each do |page|
      page.save_issue_plan_ad
    end
  end

  def copy_sample_ad
    pages.each do |page|
      page.copy_sample_ad
    end
  end

  def reset_issue_plan
    self.plan = File.open(default_issue_plan_path, 'r'){|f| f.read}
    self.save
    make_default_issue_plan
  end

  def xml_path
    path + "/newsml"
  end

  def xml_zip_path
    year          = date.year
    month         = date.month.to_s.rjust(2, "0")
    day           = date.day.to_s.rjust(2, "0")
    issue_date    = "#{year}#{month}#{day}"
    xml_path + "/#{issue_date}.zip"
  end

  def make_story_xml_zip
    require "zip/zip"

    # Path where your pdfs are situated (‘my_pdf’ is folder with pdfs)
    folder = xml_path
    input_filenames = Dir.glob("#{xml_path}/*.xml")
    zipfile_name = xml_zip_path

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        base_name = File.basename(filename)
        # Two arguments:
        # – The name of the file as it will appear in the archive
        # – The original file, including the path to find it
        zipfile.add(base_name,  File.join(folder, base_name))
      end
      # zipfile.get_output_stream(“success”) { |os| os.write “All done successfully” }
    end
    # send_file(File.join("#{Rails.root}/public/", ‘myfirstzipfile.zip’), :type => ‘application/zip’, :filename => "#{xml_zip_name}")
    # Remove content from ‘my_pdfs’ folder if you want
    # FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/my_pdfs/*"))

  end
  #
  # def make_story_xml_zip
  #   require "zip/zip"
  #   input_filenames = Dir.glob("#{xml_path}/*.xml")
  #   zipfile_name = xml_zip_path
  #   Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
  #     input_filenames.each do |filename|
  #       # Two arguments:
  #       # – The name of the file as it will appear in the archive
  #       # – The original file, including the path to find it
  #       zipfile.add(filename,  File.join(xml_path, filename))
  #     end
  #   end
  # end

  def save_story_xml
    pages.each do |page|
      page.save_story_xml
    end
    make_story_xml_zip
  end


  private

  def read_issue_plan
    if File.exist?(default_issue_plan_path)
      self.plan = File.open(default_issue_plan_path, 'r'){|f| f.read}
      return true
    else
      puts "#{default_issue_plan_path} does not exist!!!"
      return false
    end
  end
end
