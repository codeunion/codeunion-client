require "codeunion/http_client"

module CodeUnion
  # Intent-revealing methods for interacting with Github with interfaces
  # that aren't tied to the api calls.
  class GithubAPI
    def initialize(access_token)
      @access_token = access_token
      @http_client = HTTPClient.new("https://api.github.com")
    end

    def create_issue(title, content, repository)
      @http_client.post("repos/#{repository}/issues", {
        "title" => title,
        "body" => content
      }, { "access_token" => @access_token })
    end
  end
end
