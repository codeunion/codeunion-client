require "faraday"
require "faraday_middleware"
require "multi_json"
require "addressable/template"

module CodeUnion
  # More friendly RESTful interactions via Faraday and Addressable
  class HTTPClient
    def initialize(api_host)
      @api_host = api_host
    end

    def get(endpoint, params = {})
      connection.get(request_url(endpoint, params)).body
    end

    def post(endpoint, body = {}, params = {})
      response = connection.post do |req|
        req.url request_url(endpoint, params)
        req.headers["Content-Type"] = "application/json"
        req.body = body.to_json
      end

      unless (200..300).cover?(response.status)
        message = "POST to #{request_url(endpoint, params)} with " +
                  "#{body} responded with #{response.status} and " +
                  "#{response.body}"
        fail(HTTPClient::RequestError, message)
      end
      response.body
    end

    def request_url(endpoint, params = {})
      expand_url({ :endpoint => endpoint, :params => params })
    end

    private

    def expand_url(options = {})
      template.expand(options)
    end

    def template
      @template ||= Addressable::Template.new("{+endpoint}{?params*}")
    end

    def connection
      @connection ||= Faraday.new(@api_host) do |conn|
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end
    class RequestError < StandardError; end
  end
end
