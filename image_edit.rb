class Image
  attr_accessor :rows, :columns, :content
  
  def initialize(rows, columns)
    @rows, @columns = rows, columns
    create_image(self.rows, self.columns)
  end
  
  def create_image(rows, columns)
    @content = Array.new(rows) { Array.new(columns, "O") }
  end
  
  def reset
    create_image(self.rows, self.columns)
  end
  
  def colorize_pixel(row, column, new_color)
    self.content[row-1][column-1] = new_color
  end
  
  def draw_vertical(column, row_start, row_end, new_color)
    (row_start-1..row_end-1).each { |row| self.content[row][column-1] = new_color }
  end
  
  def draw_horizontal(column_start, column_end, row, new_color)
    (column_start-1..column_end-1).each { |column| self.content[row-1][column] = new_color }
  end
  
  def colorize_region(row, column, new_color)
    r, c = row-1, column-1    
    old_color = self.content[r][c] #get original pixel color

    fill(r, c, old_color, new_color) #recursive 4-way flood fill
  end
  
  def fill(r, c, old_color, new_color)    
    return if (r < 0 || c < 0 || r > self.rows-1 || c > self.columns-1) #stop when reaching the image border
    return if self.content[r][c] != old_color #leave differently colored pixels alone
    self.content[r][c] = new_color if self.content[r][c] == old_color #fill color
    
    fill(r, c+1, old_color, new_color) #go east
    fill(r, c-1, old_color, new_color) #go west
    fill(r+1, c, old_color, new_color) #go south
    fill(r-1, c, old_color, new_color) #go north
  end
  
  def show
    img = String.new
    
    self.content.each do |row|
      row.each { |pixel_colour| img += pixel_colour }
      img += "\n"
    end
    
    img
  end
end


puts "\nCOMMANDS:"
puts "1.  I M N. Create a new M x N image with all pixels coloured white (O)."
puts "2.  C. Clears the table, setting all pixels to white (O)."
puts "3.  L X Y C. Colours the pixel (X,Y) with colour C."
puts "4.  V X Y1 Y2 C. Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive)."
puts "5.  H X1 X2 Y C. Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive)."
puts "6.  F X Y C. Fill the region R with the colour C. R is defined as: Pixel (X,Y) belongs to R. Any other pixel which is the same colour as (X,Y) and shares a common side with any pixel in R also belongs to this region."
puts "7.  S. Show the contents of the current image"
puts "8.  X. Terminate the session"

loop do
  print "\nEnter a command: "
    
  input = gets.chomp.split
  
  command = input[0]
  
  param1 = input[1]
  param2 = input[2]
  param3 = input[3]
  param4 = input[4]
      
  break if command == "X"
  
  if @pic then
    case command
      when "I"
        puts "Could not create image as it already exists."
      when "C"
        @pic.reset
        puts "The image has been reset to pure white!"
      when "L"
        @pic.colorize_pixel(param1.to_i, param2.to_i, param3)
        puts "The pixel on row #{param1.to_i} : column #{param2.to_i} has been colored in colour #{param3}."
      when "V"
        @pic.draw_vertical(param1.to_i, param2.to_i, param3.to_i, param4)
        puts "A vertical line of color #{param4} has been drawn in column #{param1.to_i} between rows #{param2.to_i} and #{param3.to_i}."
      when "H"
        @pic.draw_horizontal(param1.to_i, param2.to_i, param3.to_i, param4)
        puts "A horizontal line of color #{param4} has been drawn in row #{param3.to_i} between column #{param1.to_i} and #{param2.to_i}."
      when "F"
        @pic.colorize_region(param1.to_i, param2.to_i, param3)
        puts "A region of the image has been 4-way fill flooded with color #{param3}."
      when "S"
        puts "The image currently looks as below:\n"
        puts @pic.show
      else
        puts "Oops...Wrong command! Try again."
    end
  else
    case command
      when "I"
        unless param1.nil? && param2.nil?
          if param1.to_i >= 1 && param1.to_i <= 250 && param2.to_i >= 1 && param2.to_i <= 250 then
            @pic = Image.new(param1.to_i, param2.to_i)
            puts "Created #{@pic.rows}x#{@pic.columns} pixels white image."
          else
            puts "Image dimensions must be positive integers and image size cannot be above 250x250 pixels."
          end
        else
          puts "Please specify image width and height in pixels."
        end
      when "C" , "L" , "V" , "H" , "F" , "S"
        puts "You need to create an image with the command 'I' first."
      else 
        puts "Oops...Wrong command! Try again."
    end
  end
  
end

puts "\nexiting..."
puts ""

