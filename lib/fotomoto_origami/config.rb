require 'yaml'
require 'erb'

module FotomotoOrigami
  class Config
    ORIGAMI_BASE_URL_MAPPING = {
      :production => "http://origami.fotomoto.com",
      :test => "http://my.integration.fotomoto.in:3000",
      :development => "http://localhost:3000"
    } unless defined? ORIGAMI_BASE_URL_MAPPING

    attr_accessor :origami_base_url, :callback

    def initialize(env=nil, config_override={})
      config = YAML.load(ERB.new(File.new(config_filepath).read).result)[env]
      raise "Could not load settings from config file" unless config
      config.merge!(config_override) unless config_override.nil?

      if config["retain_requests_for_test"] == true
        @retain_requests_for_test = true
      else
        fo_env = env.to_sym

        @origami_base_url = ORIGAMI_BASE_URL_MAPPING[fo_env]

        
        config.update(config){ |key,v| v.to_s }
        @callback = config['callback'] unless config['callback'].empty?
        @origami_base_url = config['base_uri'] unless config['base_uri'].empty?
      end
    end

    def config_filepath
      if defined?(Rails)
        Rails.root.join("config", "fotomoto_origami.yml")
      else
        File.join(File.dirname(__FILE__), "..", "..", "config", "fotomoto_origami.yml")
      end
    end

    def retain_requests_for_test?
      !!@retain_requests_for_test
    end
  end

  def self.config(env = nil)
    env ||= default_env_for_config
    raise "Please provide an environment" unless env
    @configs ||= Hash.new
    @configs[env] ||= Config.new(env)
  end

  private

  def self.default_env_for_config
    defined?(Rails) ? Rails.env : "development"
  end
end
