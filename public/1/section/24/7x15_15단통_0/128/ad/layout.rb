
RLayout::NewsAdBox.new(is_ad_box: true, column: 7, row: 15, grid_width: 146.99664257142854, grid_height: 97.322846, page_heading_margin_in_lines: 3) do
  image(image_path: 'some_image_path', layout_expand: [:width, :height])
  relayout!
end
