# require "codeunion"
require "codeunion/http_client"

module CodeUnion
  # A simple module for interacting with the CodeUnion API
  class API
    attr_reader :http_client
    def initialize(host, version)
      @http_client = HTTPClient.new("http://#{host}/#{version}")
    end

    def search(params = {})
      http_client.get("search", params)
    end
  end
end
