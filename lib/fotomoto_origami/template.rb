module FotomotoOrigami
  class Template
  
    attr_accessor :name, :description, :placeholders, :base_image_uri, :rotate 
    
    def attributes 
      {
        'name'           => name,
        'description'    => description,
        'base_image_uri' => base_image_uri, 
        'rotate'         => rotate,
        'placeholders'   => placeholders.map(&:attributes)
      }
    end
    
    def serialize(object)
      object.attributes
    end

    def deserialize(hash = false)
      return nil unless hash
      Template.new.tap{|nt| nt.deserialization(hash)}
    end

    def ==(other)
      other && self.attributes.eql?(other.attributes)
    end
    protected

    def deserialization(hash)
      placeholder_attributes = hash.delete('placeholders') || []
      hash.each_pair{|k, v| self.send("#{k}=", v) }
      self.placeholders = placeholder_attributes.map{|p| FotomotoOrigami::Placeholder.new(p["placeholder"]) }
    end
    
  end
end
