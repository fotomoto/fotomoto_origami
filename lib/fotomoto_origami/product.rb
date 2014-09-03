module FotomotoOrigami
  class Product
  
    attr_accessor :crop_width, :crop_height, :crop_left, :crop_top, :image_uri, :text_message, :rotated, :size, :crop
    attr_accessor :image_uri_width, :image_uri_height, :pointsize, :text_align, :font_family, :font_style, :white_image
    attr_accessor :image_lowres_width, :image_lowres_height
    TEXT_ALIGN = {
      :center => "CenterGravity",
      :top_center => "NorthGravity",
      :top_left => "NorthWestGravity",
      :top_right => "NorthEastGravity",
      :left_center => "WestGravity",
      :right_center => "EastGravity",
      :left_bottom => "SouthWestGravity",
      :bottom_center => "SouthGravity",
      :bottom_right => "SouthEastGravity"
    }
    
    def initialize(size="", rotated=false)
      @white_image = "http://img.fotomoto.com/templates/white.gif"
      @crop_top = 0
      @crop_left = 0
      @text_message = ""
      @size = ""
      @crop = false
      @crop_width = 0
      @crop_height = 0
      @image_lowres_width = 0
      @image_lowres_height = 0
      @pointsize = 50
      @font_style = "NormalStyle"
      @font_family = "helvetica"
      @text_align = TEXT_ALIGN[:top_center]
      @image_uri_width = nil
      @image_uri_height = nil
      @rotated = rotated
      self
    end
    
    def process_crop
      operand = {}
      x = 0
      y = 0

      y = @crop_top
      x = @crop_left

      actual_width = @image_uri_width # image width
      actual_height = (@crop_height * actual_width / @crop_width.to_f).round

      if actual_height > @image_uri_height # pick a wrong side
        actual_height = @image_uri_height
        actual_width = (actual_height * (@crop_width.to_f / @crop_height)).round
      end


      y = (y * ( actual_height / @crop_height.to_f)).round
      x = (x * ( actual_width / @crop_width.to_f)).round


      x = 0 if x < 0
      y = 0 if y < 0

      #x = @image_uri_width - actual_width if x + actual_width > @image_uri_width
      #y = @image_uri_height - actual_height if y + actual_height > @image_uri_height


      operand[:width] = actual_width
      operand[:height] = actual_height
      operand[:left] = x
      operand[:top] = y
      operand
    end
    
  end
end
  
