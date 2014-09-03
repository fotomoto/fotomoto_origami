require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FotomotoOrigami" do
  it "creates a client object and reads a template" do
    client = FotomotoOrigami::Client.new
    #puts client.get_templates.first["template"].inspect
    client.get_templates.first["template"].should_not == nil
  end
end
