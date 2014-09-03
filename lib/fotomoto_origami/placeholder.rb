module FotomotoOrigami
  class Placeholder
    attr_accessor :width, :height, :left, :top, :rotate, :annotations
    
    def initialize(vars={})
      vars.each_pair{|k, v| send("#{k}=", v)}
    end
    
  end
end