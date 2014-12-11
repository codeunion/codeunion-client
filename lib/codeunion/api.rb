# require "codeunion"
require "faraday"
require "faraday_middleware"
require "multi_json"
require "addressable/template"

module CodeUnion
  # A simple module for interacting with the CodeUnion API
  class API
    def initialize(host, version)
      @api_host = "http://#{host}/#{version}"
    end

    def search(params = {})
      get("search", params)
    end

    def get(endpoint, params = {})
      connection.get(request_url(endpoint, params)).body
    end

    def request_url(endpoint, params = {})
      expand_url(:endpoint => endpoint, :params => params)
    end

    private

    def expand_url(options = {})
      template.expand(options)
    end

    def template
      @template ||= Addressable::Template.new("{endpoint}{?params*}")
    end

    def connection
      @connection ||= Faraday.new(@api_host) do |conn|
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
