
RLayout::Container.new(width:158.74015748031, height: 162.83914494488) do
  line(x: 0 , y: 1.25, width: 158.74015748031, stroke_width: 2, height:0, stroke_color:'CMYK=0,0,0,100')
  text('홍길동의 칼럼', x: 0, y:8, font: 'KoPubDotumPB', font_size: 12, width: 170, text_color:'CMYK=0,0,0,100')
  rect(x: 0, y: 70, width:158.74015748031, height: 65,  fill_color:'CMYK=0,0,0,10')
  
    
    image(local_image: '홍길동.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
  
  container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
    
      text('활빈당', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear', text_color:'CMYK=0,0,0,100' )
      text('당수', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear', text_color:'CMYK=0,0,0,100')
    
  end
end
