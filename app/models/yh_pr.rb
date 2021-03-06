# == Schema Information
#
# Table name: yh_prs
#
#  id              :bigint(8)        not null, primary key
#  action          :string
#  service_type    :string
#  content_id      :string
#  date            :date
#  time            :time
#  urgency         :string
#  category        :string
#  class_code      :string
#  attriubute_code :string
#  source          :string
#  credit          :string
#  region          :string
#  title           :string
#  comment         :string
#  body            :string
#  appenddata      :string
#  taken_by        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class YhPr < ApplicationRecord
    validates_uniqueness_of :content_id
  
    def source_path
        require 'date'
        today = Date.today
        today_string = today.strftime("%Y%m%d")
        @filename_date = content_id.split("/").last.scan(/\d{3,8}/).first
        "/wire_source/401_PR/#{@filename_date}"
        # "/Volumes/211.115.91.190/101_KOR/#{Issue.last.date_string}"
        # "/Volumes/211.115.91.190/203_GRAPHIC/#{Issue.last.date_string}"
    end

    def full_size_path
        return unless appenddata
        full_size = appenddata.split("/").last
        source_path + "/#{full_size}"
    end

    def preview_path
        return unless appenddata
        preview = appenddata.split("/").last
        source_path + "/#{preview}"
    end

    def thumb_path
        return unless appenddata
        thumb = appenddata.split("/").last
        source_path + "/#{thumb}"
    end

    def taken(user)
        self.taken_by = user.name
        self.save
    end

    def self.delete_week_old(today)
        one_week_old = today.days_ago(7)
        YhPr.all.each do |pr|
            pr.destroy if pr.created_at < one_week_old
        end
    end
end
