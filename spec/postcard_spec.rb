require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Postcard" do
  it "create a postcard" do
    postcard = FotomotoOrigami::Postcard.new("4x8",true)
    #puts postcard.back_template.inspect
    postcard.back_template.should_not == nil
  end
end
