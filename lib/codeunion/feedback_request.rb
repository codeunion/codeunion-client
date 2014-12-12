require "uri"
require 'codeunion/github_api'

module CodeUnion
  class FeedbackRequest
    MISSING_ARTIFACT = "You must provide something to provide feedback on"
    INVALID_ARTIFACT = "The artifact provided was not a web URL. We only provide feedback on code hosted online."

    ISSUE_TITLE = "Please give my code feedback. Submitted #{Time.now}"

    attr_reader :artifact

    def initialize(artifact, github_token, feedback_repository, options = {})
      @github_api = options.fetch(:github_api, GithubAPI).new(github_token)
      @artifact = artifact
      @feedback_repository = feedback_repository
    end

    def send!
      @github_api.create_issue(ISSUE_TITLE, @artifact, @feedback_repository)
    end

    def valid?
      errors.empty?
    end

    def errors
      errors = []
      errors.push(MISSING_ARTIFACT) if artifact.empty?
      errors.push(INVALID_ARTIFACT) unless is_url?(artifact)

      errors.join("\n")
    end

    private
    def is_url?(url)
      url =~ /\A#{URI::regexp(['http', 'https'])}\z/
    end
  end
end
