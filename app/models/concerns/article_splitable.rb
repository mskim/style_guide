module ArticleSplitable
  extend ActiveSupport::Concern

  def article_rect
    [grid_x, grid_y, column, row]
  end

  def preferable_direction
    rect = article_rect
    if rect[2] >= rect[3]
      direction = 'vertical'
    else
      direction = 'horizontal'
    end
    direction
  end

  def v_splitable?
    column > 1
  end

  def h_splitable?
    row > 1
  end

  def splitable?
    v_splitable? || h_splitable?
  end

  def split_rect(options={})
    rect = article_rect
    if rect[2] < 2 && rect[3] < 2
      puts "article is too small to split!!!"
      return false
    end
    direction = options[:direction]
    direction = preferable_direction     unless direction
    if direction == "vertical" || direction == "v"
      if rect[2] < 2
        puts "article is too small to split!!!"
        return false
      end
      first_width   = rect[2]/2
      second_x      = rect[0] + first_width
      second_width  = rect[2] - first_width
      [[rect[0], rect[1], first_width, rect[3]], [second_x, rect[1], second_width, rect[3]]]
    else
      if rect[3] < 2
        puts "article is too small to split!!!"
        return false
      end
      first_height   = rect[3]/2
      second_y       = rect[1] + first_height
      second_height  = rect[3] - first_height
      first_rect     = [rect[0], rect[1], rect[2], first_height]
      second_rect    = [rect[0], second_y, rect[2], second_height]
      [first_rect, second_rect]
    end
  end

  def split(options={})
    result = split_rect(options)
    parent.split_article_in_page(self, result) if result
  end

  def parent
    if self.class == Article
      section
    elsif self.class == WorkingArticle
      page
    end
  end

end
