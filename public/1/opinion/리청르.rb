
RLayout::Container.new(width:171.496083,  height: 165.219) do
  line(x: 0 , y:1, width: 171.496083, stroke_width: 2, height:0)
  text('중국시평', y:5, font_size: 9)
  rect(x: 0, y: 70, width:171.496083, height: 65,  fill_color:'lightGray')
  image(local_image: '1.jpg', y: 60, width: 60, height: 75)
  container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
    text('리청르', y:15, font_size: 9, fill_color: 'clear')
    text('중국사회과학원', y:25, font_size: 9, fill_color: 'clear')
    text('선임연구원', y:35, font_size: 9, fill_color: 'clear') if true
  end
end

