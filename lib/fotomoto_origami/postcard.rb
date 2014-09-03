module FotomotoOrigami
  
  class Postcard < Product
    
    attr_accessor :front_template, :back_template, :copyright_text, :copyright_text_color, :copyright_pointsize, :copyright_font_family, :copyright_font_style, :copyright_text_align
    
    def initialize(size="4x55", rotated=true)
      super(size, rotated)
      @rotated = rotated
      @size = size
      @pointsize = 24
      @text_align = FotomotoOrigami::Product::TEXT_ALIGN[:top_left]
      @copyright_text = ""
      @copyright_text_color = "#4e4e4e" # Fotomoto Text
      @copyright_pointsize = 36
      @copyright_font_family = "Helvetica"
      @copyright_font_style = "NormalStyle"
      @copyright_text_align = FotomotoOrigami::Product::TEXT_ALIGN[:top_left]
      #if !@rotated
      #  @copyright_text_align = FotomotoOrigami::Product::TEXT_ALIGN[:left_bottom]
      #end
      search_front = "card_#{size}Post_v_1" if @rotated
      search_front = "card_#{size}Post_h_1" if not @rotated
      search_back = "card_#{size}Post_v_2" if @rotated
      search_back = "card_#{size}Post_h_2" if not @rotated
      FotomotoOrigami::Client.new.get_templates.each do |template|
        if not template["template"]["name"].match("#{search_front}").nil?
          @front_template = FotomotoOrigami::Template.new.deserialize(template["template"])
        end
      end
      FotomotoOrigami::Client.new.get_templates.each do |template|
        if not template["template"]["name"].match("#{search_back}").nil?
          @back_template = FotomotoOrigami::Template.new.deserialize(template["template"])
        end
      end
    end
    
    def process index, front=true
      operands = []
      operand = {}
      if front
        operand = {:image_uri=>@image_uri, :placeholder_id=>index}
        if @crop
          operand.merge! self.process_crop
        else
          operand[:width] = @image_uri_width
          operand[:height] = @image_uri_height
          operand[:left] = 0
          operand[:top] = 0
        end
      else
        if @size == "4x55"
          operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/4x55Post.jpg", :placeholder_id=>index, :width=>1719, :height=>1269}
        elsif @size == "5x5"
          operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x5Post_1.jpg", :placeholder_id=>index, :width=>1569, :height=>1569}
        elsif @size == "4x8"
          if @rotated
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/4x8Post_v_2.jpg", :placeholder_id=>index, :width=>1269, :height=>2469}
          else
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/4x8Post_h_2.jpg", :placeholder_id=>index, :width=>2469, :height=>1269}
          end
        else
          if @rotated       
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x7Post_v_2.jpg", :placeholder_id=>index, :width=>1569, :height=>2169}
          else
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x7Post_h_2.jpg", :placeholder_id=>index, :width=>2169, :height=>1569}
          end
        end
        operand[:left] = 0
        operand[:top] = 0
        annotations = []
        #if size == "4x55"
        #  if not @copyright_text.empty?
        #    annotation = {:text=>@copyright_text,:annotation_id=>1,:fill=>@copyright_text_color,:gravity=>@copyright_text_align, :pointsize=>@copyright_pointsize,:font_family=>@copyright_font_family,:font_style=>@copyright_font_style}
        #    annotations << annotation
        #  end  
        #  if not @text_message.empty?
        #    annotation = {:text=>@text_message,:annotation_id=>0,:pointsize=>@pointsize,:gravity=>@text_align,:font_family=>@font_family,:font_style=>@font_style}
        #    annotations << annotation
        #  end
        #else
          if not @text_message.empty?
            annotation = {:text=>@text_message,:annotation_id=>0,:pointsize=>@pointsize,:gravity=>@text_align,:font_family=>@font_family,:font_style=>@font_style}
            annotations << annotation
          end
          if not @copyright_text.empty?
            annotation = {:text=>@copyright_text,:annotation_id=>1}
            annotations << annotation
          end
          #end
        operand[:annotations] = annotations
      end
      operands << operand
    end
  end
  
end
  
