require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

module Nozbe
  # Base class for all API call
  # - The Nozbe API is based on JSON responses
  # - This class is inspired by the deliciousr project
  class ApiCall
    API_BASE_URL = 'http://www.nozbe.com:80/api'
    
    attr_accessor :action, :parameters
    attr_reader :required_parameters

    # define the action to call ('new_project', 'actions', and so on...)
    # - Sub-classes MUST define this !!
    def self.action(action)
      define_method :action do
        action.to_sym
      end
    end

    # define the user_key and all parameters for the API-call
    # - Sub-classes should override this method to provide a more user-friendly signature
    def initialize(key, parameters={})
      @parameters = parameters
      @parameters["key"] = key if key
    end

    # execute the API-Call, and return the parsed reponse
    def call()
      json = do_request()
      parse(json)
    end

    # low-level method that do the request, and return the body response (without any parsing)
    def do_request()
      uri = URI.parse(API_BASE_URL + build_request_path())
      response = Net::HTTP.get_response(uri)
      response.body
    end

    # method provides a default parsing strategy for the JSON-response
    # - Sub-classes should override this method to provide a specific parsing of the response
    def parse(json)
      JSON.parse(json) rescue nil
    end

    # build the request path based on the given action and built query string
    def build_request_path()
      path = "/#{self.action}"
      if query_string = build_query_string
        path += "/#{query_string}"
      end
      path
    end
    
    # build the query string based on the given parameters
    # - the Nozbe-API convention is to use '.../paramkey-paramvalue/...'
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
    
    # helper method that 'url-encode' the given parameter and return it
    def url_encode(param)
      URI.escape(param, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    
  end
end
