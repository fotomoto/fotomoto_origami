require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  it "create a 4x55 and back postcard for the front vertical" do
    templates = {}
    order_id = Time.now.to_s
    postcard = FotomotoOrigami::Postcard.new("4x55",true)
    postcard.image_uri = "http://www.download.hr/forum/attachments/hot/2352d1228154661-hot-girls-wallpapers-barbara-stoyanoff-1920x1200-008_hot_girl.jpg"
    postcard.image_uri_width = 1920
    postcard.image_uri_height = 1200
    postcard.crop_width = 257
    postcard.crop_height = 364
    postcard.crop_top = 0
    postcard.crop_left = 31
    postcard.crop = true
    postcards = []
    postcards << postcard
    templates["postcard_front"] = postcards
    
    back_postcard = FotomotoOrigami::Postcard.new("4x55",false)
    back_postcard.pointsize = 48
    #postcard.text_align = FotomotoOrigami::Product::TEXT_ALIGN[:bottom_right]
    back_postcard.text_message = "Hello America vertical"
    back_postcard.copyright_text = "Image by Bob Milani"
    back_postcards = []
    back_postcards << back_postcard
    templates["postcard_back"] = back_postcards
    
    
    greeting_card_1 = FotomotoOrigami::GreetingCard.new("5x7", true)
    
    greeting_card_1.pointsize = 48
    greeting_card_1.text_message = "I love this country in vertical\n Good Morning America."
    greeting_card_1.font_family = "Myriad Pro,Myriad Pro Cond"

    greeting_cards = []
    greeting_cards << greeting_card_1
    templates["greeting_back"] = greeting_cards
    
    client = FotomotoOrigami::Client.new
    response = client.process_template(templates, order_id)
    puts response.inspect
  end
  


  
  
end
