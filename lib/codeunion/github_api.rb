require 'codeunion/http_client'
module CodeUnion
  class GithubAPI
    def initialize(access_token)
      @access_token = access_token
      @http_client = HTTPClient.new("https://api.github.com")
    end

    def create_issue(title, content, repository)
      org, repo = repository.split("/")
      @http_client.post(["repos", org, repo, "issues"], {
        "title" => title,
        "body" => content
      }, { "access_token" => @access_token })
    end
  end
end
