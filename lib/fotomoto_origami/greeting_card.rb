module FotomotoOrigami
  
  class GreetingCard < Product
    
    attr_accessor :front_template, :back_template, :copyright_text, :copyright_text_color, :copyright_pointsize, :copyright_font_family, :copyright_font_style, :copyright_text_align
    
    def initialize(size="5x7", rotated=true)
      super(size, rotated)
      @rotated = rotated
      @size = size
      @copyright_text = ""
      @copyright_text_color = "#4e4e4e" # Fotomoto Text
      @copyright_pointsize = 36
      @copyright_font_family = "helvetica"
      @copyright_font_style = "NormalStyle"
      @copyright_text_align = FotomotoOrigami::Product::TEXT_ALIGN[:center]
      #if !@rotated
      #  @copyright_text_align = FotomotoOrigami::Product::TEXT_ALIGN[:left_bottom]
      #end
      
      search_front = "card_#{size}Folded_v_1" if @rotated
      search_front = "card_#{size}Folded_h_1" if not @rotated
      search_back = "card_#{size}Folded_v_2" if @rotated
      search_back = "card_#{size}Folded_h_2" if not @rotated
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
        if @rotated #Back Front
          if @size == "5x5"
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x5SideFold_1.jpg", :placeholder_id=>index, :width=>748, :height=>765, :top=>0, :left=>0}
          else
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x7Folded_v_1.jpg", :placeholder_id=>index, :width=>1529, :height=>2169, :top=>0, :left=>0}
          end
          if not @copyright_text.empty?
            annotations = []
            annotation = {:text=>@copyright_text,:annotation_id=>0}
            annotations << annotation
            operand[:annotations] = annotations
          end
          operands << operand
          operand = {:image_uri=>@image_uri, :placeholder_id=>index+1}
          if @crop
            operand.merge! self.process_crop
          else
            operand[:width] = @image_uri_width
            operand[:height] = @image_uri_height
            operand[:left] = 0
            operand[:top] = 0
          end
          operands << operand
        else
          operand = {:image_uri=>@image_uri, :placeholder_id=>index}
          if @crop
            operand.merge! self.process_crop
          else
            operand[:width] = @image_uri_width
            operand[:height] = @image_uri_height
            operand[:left] = 0
            operand[:top] = 0
          end
          operands << operand
                  

          annotation_index = index+2
          if @size == "5x5"
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x5Folded_h_1.jpg", :placeholder_id=>annotation_index, :width=>780, :height=>765, :top=>0, :left=>0}
          else
            operand = {:image_uri=>"http://img.fotomoto.com/templates/backs/5x7Folded_h_1.jpg", :placeholder_id=>annotation_index, :width=>2169, :height=>1529, :top=>0, :left=>0}
          end

          if not @copyright_text.empty?
            annotations = []
            annotation = {:text=>@copyright_text,:annotation_id=>0}
            annotations << annotation
            operand[:annotations] = annotations
          end
          operands << operand
        end
        
        operands
      else
        operand = {:image_uri=>@white_image, :placeholder_id=>index}
        operand[:width] = @back_template.placeholders.first.width
        operand[:height] = @back_template.placeholders.first.height
        operand[:left] = 0
        operand[:top] = 0
        
        operands << operand
        if @rotated
          annotation_index = index+1
        else
          annotation_index = index+2
        end         
        operand = {:image_uri=>@white_image, :placeholder_id=>annotation_index}

        operand[:width] = @back_template.placeholders.first.width
        operand[:height] = @back_template.placeholders.first.height
        operand[:left] = 0
        operand[:top] = 0
        if not @text_message.empty?
          annotations = []
          annotation = {:text=>@text_message,:annotation_id=>0,:pointsize=>@pointsize,:gravity=>@text_align,:font_family=>@font_family,:font_style=>@font_style}
          annotations << annotation
          operand[:annotations] = annotations
        end
        operands << operand
        operands
      end
    end
  end
  
end
  
