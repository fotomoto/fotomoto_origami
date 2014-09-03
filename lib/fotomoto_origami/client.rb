require 'httparty'

module FotomotoOrigami
  class Client
    
    include HTTParty
    
    def initialize(env = nil)
      @env = env
      config = FotomotoOrigami.config(env)
      @api_base_url = config.origami_base_url
      @callback = config.callback
    end
    
    def get_templates
      HTTParty.get("#{@api_base_url}/templates/list.json")["templates"]
    end
  
    def check_job_status(process_id)
      uri = "#{@api_base_url}/processes/show/#{process_id}.json"
      HTTParty.get(uri)
    end
    
    def asynch_thumbnailer(payload)
      response = HTTParty.post("#{@api_base_url}/dispatcher/thumbnailer/create.json", :body=>payload.to_json)

      return [payload, response, true] if response.code == 200
      return [payload, response, false]
    end
    
    def process_template(templates, ref_id)
      processes = []
      templates.each do |key, products|
        front = false
        if not key.match("front").nil?
          front = true
        end
        template_to_process = {}
        template_to_process[:template_id] = products.first.front_template.name if front
        template_to_process[:template_id] = products.first.back_template.name if not front
        template_to_process[:order_id] = ref_id
        template_to_process[:callback] = @callback
        index = 0
        operands = []
        placeholder_ids = []
        products.each do |product|
          #puts "index is: #{index}"
          created_operands = product.process(index, front)
          created_operands.each do |operand|
            placeholder_ids << operand[:placeholder_id]
          end
          operands << created_operands
          current_index = 0
          placeholder_ids.uniq!
          placeholder_ids.sort!
          placeholder_ids.each do |placeholder_id|
            #puts placeholder_id
            #puts current_index
            if current_index != placeholder_id
              index = current_index
              break
            else
              current_index = current_index + 1
              index = current_index
            end
          end
        end
        operands.flatten!
        template_to_process[:operands] = operands
        process = {:process=>template_to_process}
        processes << process
      end
      send_info= {:cohort=>processes}
      #puts send_info.inspect
      response = HTTParty.post("#{@api_base_url}/dispatcher/create.json", :body=>send_info.to_json)

      return [send_info, response, true] if response.code == 200
      return [send_info, response, false]

    end
    
  end
  
end
