require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

module Nozbe
  class ApiCall
    API_BASE_URL = 'http://www.nozbe.com:80/api'
    
    attr_accessor :action, :parameters
    attr_reader :required_parameters
      
    def self.action(action)
      define_method :action do
        action.to_sym
      end
    end

    def initialize(key, parameters={})
      @parameters = parameters
      @parameters["key"] = key if key
    end

    def call()
      json = do_request()
      parse(json)
    end

    def do_request()
      uri = URI.parse(API_BASE_URL + build_request_path())
      response = Net::HTTP.get_response(uri)
      response.body
    end

    def parse(json)
      JSON.parse(json) rescue nil
    end

    def build_request_path()
      path = "/#{self.action}"
      if query_string = build_query_string
        path += "/#{query_string}"
      end
      path
    end
    
    def build_query_string()
      unless parameters.nil? || parameters.empty?
        query_strings = parameters.keys.sort {|a,b|
          a.to_s <=> b.to_s
        }.inject([]) do |result, element|
          value = parameters[element]
          value = value.join(";") if value.class == Array
          result << "#{element.to_s}-#{value.to_s}"
        end
        query_strings.join('/')
      else
        nil
      end
    end
    
    def url_encode(param)
      URI.escape(param, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    
  end
end
